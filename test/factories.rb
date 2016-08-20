FactoryGirl.define do
  factory :layout do
    name 'Turtle'
    tile_positions {
      lines = File.readlines(Rails.root.join('layouts', 'turtle.txt'))
      lines.map(&:strip).join('')
    }
  end

  factory :user do
    email 'arnie@example.com'
    password 'sup3r53cr37'
  end

  factory :game do
    user
    layout
  end
end
