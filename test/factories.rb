FactoryGirl.define do
  factory :layout do
    name 'Turtle'
    tile_positions { File.read(Rails.root.join('layouts', 'turtle.txt')) }
  end

  factory :user do
    email 'arnie@example.com'
    password 'sup3r53cr37'
  end

  factory :game do
    user
  end
end
