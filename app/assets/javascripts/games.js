(function() {
  var selectedTile = null
  var resizeTimeout = false

  function hookUpTileLinks() {
    const links = document.querySelectorAll('a.mahjong-tile.selectable')
    links.forEach(function(link) {
      link.addEventListener('click', selectTile)
    })
  }

  function tileCoordinates(tile) {
    const coordinates = tile.getAttribute('data-coords')
    var coordsList = coordinates.split(',')
    const x = parseInt(coordsList[0], 10)
    const y = parseInt(coordsList[1], 10)
    const z = parseInt(coordsList[2], 10)
    return { x: x, y: y, z: z }
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
    const toTheRight = tiles.filter(function(otherTile) {
      const otherCoordinates = tileCoordinates(otherTile)
      return otherCoordinates.x > coordinates.x &&
          otherCoordinates.y === coordinates.y &&
          otherCoordinates.z === coordinates.z
    })[0]
    return toTheRight
  }

  function tileBelow(tile, tiles) {
    const coordinates = tileCoordinates(tile)
    const below = tiles.filter(function(otherTile) {
      const otherCoordinates = tileCoordinates(otherTile)
      return otherCoordinates.x === coordinates.x &&
          otherCoordinates.y > coordinates.y &&
          otherCoordinates.z === coordinates.z
    })[0]
    return below
  }

  function boundedTile(tiles) {
    const boundedTiles = tiles.filter(function(tile) {
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

  function adjustBoardSize() {
    const board = document.getElementById('game-board')
    const maxWidth = window.innerWidth - 362
    const maxHeight = window.innerHeight - 26
    const idealWidth = maxHeight * 1.6
    if (idealWidth <= maxWidth) {
      board.style.width = `${idealWidth}px`
      board.style.height = `${maxHeight}px`
    } else {
      board.style.width = `${maxWidth}px`
      board.style.height = `${maxWidth * 0.6}px`
    }
  }

  function adjustTileSizes() {
    clearTimeout(resizeTimeout)
    const tiles = Array.from(document.querySelectorAll('.mahjong-tile.is-visible'))
    tiles.sort(sortByCoordinates)

    // Ideal ratio:
    const imageW = 37
    const imageH = 46
    const imageR = imageW / imageH

    var scaledW = imageW
    var scaledH = imageH

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

    tiles.forEach(function(tile) {
      tile.style.width = scaledW + 'px'
      tile.style.height = scaledH + 'px'

      const coordinates = tileCoordinates(tile)
      if (coordinates.z > 0) {
        const image = tile.querySelector('.tile-image')
        const factor = coordinates.z * 2
        image.style.marginLeft = '-' + factor + 'px'
        image.style.marginTop = '-' + factor + 'px'
        image.style.boxShadow = '3px 3px 3px rgba(0, 0, 0, ' + (0.3 * coordinates.z) + ')'
      }

      tile.classList.add('is-sized')
    })
  }

  function adjustBoardAndTileSizes() {
    adjustBoardSize()
    adjustTileSizes()
  }

  function updateGameBoard(html) {
    selectedTile = null
    document.getElementById('game-board').innerHTML = html
    hookUpTileLinks()
    adjustTileSizes()
    getUpdatedState()
  }

  function tileProperties(tile) {
    const coordinates = tile.getAttribute('data-coords')
    const category = tile.getAttribute('data-category')
    const set = tile.getAttribute('data-set')
    const suit = tile.getAttribute('data-suit')
    const number = tile.getAttribute('data-number')
    const name = tile.getAttribute('data-name')
    return {
      coordinates: coordinates,
      category: category,
      set: set,
      suit: suit,
      number: number,
      name: name
    }
  }

  function tileMatchProperties(tile) {
    const id = tile.getAttribute('data-tile-id')
    const coordinates = tile.getAttribute('data-coords')
    const matchUrl = tile.getAttribute('data-match-url')
    return {
      id: id,
      coordinates: coordinates,
      matchUrl: matchUrl
    }
  }

  // Keep in sync with Tile#match?
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
    const gameBoard = document.getElementById('game-board')
    const tiles = props1.id + ':' + props1.coordinates + ';' + props2.id + ':' + props2.coordinates
    const joiner = props1.matchUrl.indexOf('?') > -1 ? '&' : '?'
    const url = props1.matchUrl + joiner + 'tiles=' + encodeURIComponent(tiles)
    const data = {}
    if (gameBoard.hasAttribute('data-tiles')) {
      data.previous_tiles = gameBoard.getAttribute('data-tiles')
    }
    $.ajax({
      url: url,
      type: 'POST',
      dataType: 'html',
      data: data
    }).done(function(response) {
      updateGameBoard(response)
    }).fail(function(jqXHR, status, error) {
      selectedTile = null
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

  function getUpdatedState() {
    const gameState = document.getElementById('game-state')
    const stateUrl = gameState.getAttribute('data-url')
    $.ajax({
      url: stateUrl,
      type: 'GET',
      dataType: 'html'
    }).done(function(stateResponse) {
      gameState.innerHTML = stateResponse
      hookUpShuffleButton()
      hookUpResetButton()
      hookUpNewGameButton()
    }).fail(function(jqXHR, status, error) {
      console.error('failed to update game state', jqXHR, status, error)
    })
  }

  function shuffleTiles() {
    const gameBoard = document.getElementById('game-board')
    const shuffleUrl = gameBoard.getAttribute('data-shuffle-url')
    const data = {}
    if (gameBoard.hasAttribute('data-tiles')) {
      data.previous_tiles = gameBoard.getAttribute('data-tiles')
    }
    $.ajax({
      url: shuffleUrl,
      type: 'POST',
      dataType: 'html',
      data: data
    }).done(function(response) {
      updateGameBoard(response)
    }).fail(function(jqXHR, status, error) {
      console.error('failed to shuffle tiles', tiles, jqXHR, status, error)
    })
  }

  function startNewGame() {
    const gameBoard = document.getElementById('game-board')
    const newGameUrl = gameBoard.getAttribute('data-new-game-url')
    window.location = newGameUrl
  }

  function resetGame() {
    const gameBoard = document.getElementById('game-board')
    const resetUrl = gameBoard.getAttribute('data-reset-url')
    $.ajax({
      url: resetUrl,
      type: 'POST',
      dataType: 'html'
    }).done(function(response) {
      updateGameBoard(response)
    }).fail(function(jqXHR, status, error) {
      console.error('failed to reset game', tiles, jqXHR, status, error)
    })
  }

  function hookUpNewGameButton() {
    const button = document.getElementById('new-game-button')
    if (!button) {
      return
    }
    button.addEventListener('click', function(event) {
      if (window.confirm('Are you sure you want to start a new game?')) {
        startNewGame()
      }
    })
  }

  function hookUpResetButton() {
    const button = document.getElementById('reset-game-button')
    if (!button) {
      return
    }
    button.addEventListener('click', function(event) {
      if (window.confirm('Are you sure you want to reset your game?')) {
        resetGame()
      }
    })
  }

  function hookUpShuffleButton() {
    const button = document.getElementById('shuffle-tiles-button')
    if (!button) {
      return
    }
    button.addEventListener('click', function(event) {
      event.preventDefault()
      shuffleTiles()
    })
  }

  function changeImage(event) {
    const radio = event.currentTarget
    const returnTo = window.location.pathname
    const imageUrl = radio.getAttribute('data-url')
    const joiner = imageUrl.indexOf('?') > -1 ? '&' : '?'
    const url = imageUrl + joiner + 'return_to=' + encodeURIComponent(returnTo)
    window.location.href = url
  }

  function hookUpImageChangeRadios() {
    const radios = document.querySelectorAll('.image-change-radio')
    radios.forEach(function(radio) {
      radio.addEventListener('click', changeImage)
    })
  }

  if (document.getElementById('game-board')) {
    $(function() {
      const csrfToken = document.querySelector('meta[name=csrf-token]').
          getAttribute('content')
      $.ajaxSetup({ headers: { 'X-CSRF-Token': csrfToken } })
      hookUpTileLinks()
      adjustBoardAndTileSizes()
      hookUpShuffleButton()
      hookUpImageChangeRadios()
      hookUpResetButton()
      hookUpNewGameButton()
    })

    $(window).resize(function() {
      if (resizeTimeout) {
        clearTimeout(resizeTimeout)
      }
      resizeTimeout = setTimeout(adjustBoardAndTileSizes, 200)
    })
  }
})()
