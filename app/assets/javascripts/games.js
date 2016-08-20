let selectedTile = null

const tileProperties = function(tile) {
  const category = tile.getAttribute('data-category')
  const set = tile.getAttribute('data-set')
  const suit = tile.getAttribute('data-suit')
  const number = tile.getAttribute('data-number')
  const name = tile.getAttribute('data-name')
  return { category, set, suit, number, name }
}

const tileMatchProperties = function(tile) {
  const id = tile.getAttribute('data-tile-id')
  const coordinates = tile.getAttribute('data-coords')
  const matchUrl = tile.getAttribute('data-match-url')
  const authToken = tile.getAttribute('data-auth-token')
  return { id, coordinates, matchUrl, authToken }
}

const isMatch = function(tileA, tileB) {
  const propsA = tileProperties(tileA)
  const propsB = tileProperties(tileB)
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

const matchTiles = function(tile1, tile2) {
  const props1 = tileMatchProperties(tile1)
  const props2 = tileMatchProperties(tile2)
  const tiles = `${props1.id}:${props1.coordinates};${props2.id}:${props2.coordinates}`
  const csrfToken = document.querySelector('meta[name=csrf-token]').getAttribute('content')
  const url = `${props1.matchUrl}?authenticity_token=${encodeURIComponent(csrfToken)}&tiles=${encodeURIComponent(tiles)}`
  const options = {
    method: 'POST',
    headers: {
      'X-CSRF-Token': csrfToken
    }
  }
  fetch(url, options).then(response => {
    if (response.status !== 200) {
      console.error('failed to match tiles', tiles, response.status, response.statusText)
      return
    }
    response.json().then(json => {
      console.log(json)
      selectedTile = null
      tile1.classList.remove('is-selected')
      tile2.classList.remove('is-selected')
      tile1.remove()
      tile2.remove()
    })
  })
}

const selectTile = function(event) {
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

const callback = function() {
  const links = document.querySelectorAll('a.mahjong-tile.selectable')
  links.forEach(link => {
    link.addEventListener('click', selectTile)
  })
}

document.addEventListener('DOMContentLoaded', callback)
