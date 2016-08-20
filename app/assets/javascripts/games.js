const selectTile = function(event) {
  event.preventDefault()
  const link = event.currentTarget
  const tileID = link.getAttribute('data-tile-id')
  const coordinates = link.getAttribute('data-coords')
  console.log(tileID, coordinates)
  link.classList.add('is-selected')
  link.blur()
}

const callback = function() {
  const links = document.querySelectorAll('a.mahjong-tile.selectable')
  links.forEach(link => {
    link.addEventListener('click', selectTile)
  })
}

document.addEventListener('DOMContentLoaded', callback)
