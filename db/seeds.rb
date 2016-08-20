Tile::SUITS.each do |suit|
  (1..9).each do |number|
    tile = Tile.create!(number: number, suit: suit, category: 'suit')
    puts "Created #{tile}"
  end
end

Tile::WIND_NAMES.each do |name|
  tile = Tile.create!(name: name, set: 'wind', category: 'honor')
  puts "Created #{tile}"
end

Tile::DRAGON_NAMES.each do |name|
  tile = Tile.create!(name: name, set: 'dragon', category: 'honor')
  puts "Created #{tile}"
end

Tile::FLOWER_NAMES.each do |name|
  tile = Tile.create!(name: name, set: 'flower', category: 'bonus')
  puts "Created #{tile}"
end

Tile::SEASON_NAMES.each do |name|
  tile = Tile.create!(name: name, set: 'season', category: 'bonus')
  puts "Created #{tile}"
end

puts '-----------------------'
puts "#{Tile.count} tiles created"

lines = File.readlines(Rails.root.join('layouts', 'turtle.txt'))
positions = lines.map(&:strip).join('')
layout = Layout.create!(name: 'Turtle', tile_positions: positions)
puts "Created layout #{layout.name}"

password = 'password123'
user = User.create!(email: 'test@example.com', password: password)
puts "Created user #{user.email} with password: #{password}"
