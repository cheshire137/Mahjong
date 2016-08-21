Tile.create_all_tiles
puts "#{Tile.count} tiles created"

lines = File.readlines(Rails.root.join('layouts', 'turtle.txt'))
positions = lines.map(&:strip).join('')
layout = Layout.create!(name: 'Turtle', tile_positions: positions)
puts "Created layout #{layout.name}"

password = 'password123'
user = User.create!(email: 'test@example.com', password: password)
puts "Created user #{user.email} with password: #{password}"
