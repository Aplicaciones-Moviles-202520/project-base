FactoryBot.define do
  factory :country do
    sequence(:iso2) { |n| Faker::Address.country_code }
    sequence(:iso3) { |n| Faker::Address.country_code_long }
    name_en { Faker::Address.country }
    name_es { Faker::Address.country }
    numeric_code { rand(100..999).to_s }
    calling_code { "+#{rand(1..99)}" }
    region { Faker::Address.state }
    subregion { Faker::Address.city }
  end
end