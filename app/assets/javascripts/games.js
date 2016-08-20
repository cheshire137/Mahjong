let selectedTile = null

const tileProperties = function(tile) {
  const category = tile.getAttribute('data-category')
  const set = tile.getAttribute('data-set')
  const suit = tile.getAttribute('data-suit')
  const number = tile.getAttribute('data-number')
  const name = tile.getAttribute('data-name')
  return { category, set, suit, number, name }
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

const selectTile = function(event) {
  event.preventDefault()
  const tile = event.currentTarget
  if (selectedTile !== null) {
    if (isMatch(selectedTile, tile)) {
      alert('match!')
    } else {
      selectedTile.classList.remove('is-selected')
      selectedTile = null
    }
  }
  const tileID = tile.getAttribute('data-tile-id')
  const coordinates = tile.getAttribute('data-coords')
  console.log(tileID, coordinates)
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
