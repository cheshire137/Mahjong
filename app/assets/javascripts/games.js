let selectedTile = null
let resizeTimeout = false

function hookUpTileLinks() {
  const links = document.querySelectorAll('a.mahjong-tile.selectable')
  links.forEach(link => {
    link.addEventListener('click', selectTile)
  })
}

function tileCoordinates(tile) {
  const coordinates = tile.getAttribute('data-coords')
  let [x, y, z] = coordinates.split(',')
  x = parseInt(x, 10)
  y = parseInt(y, 10)
  z = parseInt(z, 10)
  return { x, y, z }
}

function sortByCoordinates(a, b) {
  const aCoords = tileCoordinates(a)
  const bCoords = tileCoordinates(b)
  if (aCoords.x > bCoords.x) {
    return 1
  }
  if (aCoords.x < bCoords.x) {
    return -1
  }
  if (aCoords.y > bCoords.y) {
    return 1
  }
  if (aCoords.y < bCoords.y) {
    return -1
  }
  return aCoords.z > bCoords.z ? 1 : -1
}

function tileToRight(tile, tiles) {
  const coordinates = tileCoordinates(tile)
  const toTheRight = tiles.filter(otherTile => {
    const otherCoordinates = tileCoordinates(otherTile)
    return otherCoordinates.x > coordinates.x &&
        otherCoordinates.y === coordinates.y &&
        otherCoordinates.z === coordinates.z
  })[0]
  return toTheRight
}

function tileBelow(tile, tiles) {
  const coordinates = tileCoordinates(tile)
  const below = tiles.filter(otherTile => {
    const otherCoordinates = tileCoordinates(otherTile)
    return otherCoordinates.x === coordinates.x &&
        otherCoordinates.y > coordinates.y &&
        otherCoordinates.z === coordinates.z
  })[0]
  return below
}

function boundedTile(tiles) {
  const boundedTiles = tiles.filter(tile => {
    const tileOnRight = tileToRight(tile, tiles)
    const below = tileBelow(tile, tiles)
    if (typeof tileOnRight === 'undefined') {
      return false
    }
    if (typeof below === 'undefined') {
      return false
    }
    const coordinates = tileCoordinates(tile)
    const rightCoords = tileCoordinates(tileOnRight)
    if ((rightCoords.x - coordinates.x) > 2) {
      return false
    }
    const belowCoords = tileCoordinates(below)
    if ((belowCoords.y - coordinates.y) > 2) {
      return false
    }
    return true
  })
  return boundedTiles[0]
}

function adjustTileSizes() {
  clearTimeout(resizeTimeout)
  const tiles = Array.from(document.querySelectorAll('.mahjong-tile.is-visible'))
  tiles.sort(sortByCoordinates)

  // Ideal ratio:
  const imageW = 37
  const imageH = 46
  const imageR = imageW / imageH

  let scaledW = imageW
  let scaledH = imageH

  const constrainedTile = boundedTile(tiles)
  const gameBoard = document.getElementById('game-board')

  if (typeof constrainedTile === 'undefined') {
    if (gameBoard.hasAttribute('data-tile-width') &&
        gameBoard.hasAttribute('data-tile-height')) {
      scaledW = gameBoard.getAttribute('data-tile-width')
      scaledH = gameBoard.getAttribute('data-tile-height')
    }
  } else {
    const rightSibling = tileToRight(constrainedTile, tiles)
    const belowSibling = tileBelow(constrainedTile, tiles)

    const tileRect = constrainedTile.getBoundingClientRect()
    const rightRect = rightSibling.getBoundingClientRect()
    const belowRect = belowSibling.getBoundingClientRect()

    const availableW = rightRect.left - tileRect.left
    const availableH = belowRect.top - tileRect.top
    const availableR = availableW / availableH
    if (availableR > imageR) {
      scaledW = (imageW * availableH) / imageH
      scaledH = availableH
    } else {
      scaledW = availableW
      scaledH = (imageH * availableW) / imageW
    }

    gameBoard.setAttribute('data-tile-width', scaledW)
    gameBoard.setAttribute('data-tile-height', scaledH)
  }

  tiles.forEach(tile => {
    tile.style.width = `${scaledW}px`
    tile.style.height = `${scaledH}px`

    const coordinates = tileCoordinates(tile)
    if (coordinates.z > 0) {
      const image = tile.querySelector('.tile-image')
      const factor = coordinates.z * 2
      image.style.marginLeft = `-${factor}px`
      image.style.marginTop = `-${factor}px`
      image.style.boxShadow = `${factor}px ${factor}px ${factor}px #494949`
    }

    tile.classList.add('is-sized')
  })
}

function tileProperties(tile) {
  const coordinates = tile.getAttribute('data-coords')
  const category = tile.getAttribute('data-category')
  const set = tile.getAttribute('data-set')
  const suit = tile.getAttribute('data-suit')
  const number = tile.getAttribute('data-number')
  const name = tile.getAttribute('data-name')
  return { coordinates, category, set, suit, number, name }
}

function tileMatchProperties(tile) {
  const id = tile.getAttribute('data-tile-id')
  const coordinates = tile.getAttribute('data-coords')
  const matchUrl = tile.getAttribute('data-match-url')
  const authToken = tile.getAttribute('data-auth-token')
  return { id, coordinates, matchUrl, authToken }
}

function isMatch(tileA, tileB) {
  const propsA = tileProperties(tileA)
  const propsB = tileProperties(tileB)
  if (propsA.coordinates === propsB.coordinates) {
    return false
  }
  if (propsA.category !== propsB.category) {
    return false
  }
  if (propsA.category === 'suit') {
    if (propsA.suit !== propsB.suit) {
      return false
    }
    if (propsA.number !== propsB.number) {
      return false
    }
  }
  if (propsA.set !== propsB.set) {
    return false
  }
  if (propsA.set === 'wind' || propsA.set === 'dragon') {
    if (propsA.name !== propsB.name) {
      return false
    }
  }
  return true
}

function matchTiles(tile1, tile2) {
  const props1 = tileMatchProperties(tile1)
  const props2 = tileMatchProperties(tile2)
  const tiles = `${props1.id}:${props1.coordinates};${props2.id}:${props2.coordinates}`
  const url = `${props1.matchUrl}?tiles=${encodeURIComponent(tiles)}`
  $.ajax({
    url: url,
    type: 'POST',
    dataType: 'html'
  }).done(response => {
    document.getElementById('game-board').innerHTML = response
    hookUpTileLinks()
    adjustTileSizes()
  }).fail((jqXHR, status, error) => {
    console.error('failed to match tiles', tiles, jqXHR, status, error)
  })
}

function selectTile(event) {
  event.preventDefault()
  const tile = event.currentTarget
  if (selectedTile !== null) {
    if (isMatch(selectedTile, tile)) {
      matchTiles(selectedTile, tile)
      return
    } else {
      selectedTile.classList.remove('is-selected')
      selectedTile = null
    }
  }
  tile.classList.add('is-selected')
  tile.blur()
  selectedTile = tile
}

$(function() {
  const csrfToken = document.querySelector('meta[name=csrf-token]').
      getAttribute('content')
  $.ajaxSetup({ headers: { 'X-CSRF-Token': csrfToken } })
  hookUpTileLinks()
  adjustTileSizes()
})

$(window).resize(function() {
  if (resizeTimeout) {
    clearTimeout(resizeTimeout)
  }
  resizeTimeout = setTimeout(adjustTileSizes, 200)
})
