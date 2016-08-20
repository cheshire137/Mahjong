FactoryGirl.define do
  factory :layout do
    name 'Turtle'
  end

  factory :user do
    email 'arnie@example.com'
    password 'sup3r53cr37'
  end

  factory :game do
    user
  end
end
