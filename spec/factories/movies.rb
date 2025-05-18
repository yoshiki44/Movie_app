# frozen_string_literal: true

# spec/factories/movies.rb
FactoryBot.define do
  factory :movie do
    tmdb_id { Faker::Number.unique.number(digits: 6) }
    title { Faker::Movie.title }
    overview { Faker::Lorem.paragraph }
    poster_path { "/#{Faker::Alphanumeric.alpha(number: 10)}.jpg" }
    release_date { Faker::Date.between(from: '1990-01-01', to: Time.zone.today) }
    runtime { rand(60..180) }
    genre_ids { Array.new(2) { rand(1..20) }.join(',') }
  end
end
