let selectedTile = null

const isMatch = function(tileA, tileB) {
  return false
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
