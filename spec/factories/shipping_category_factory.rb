FactoryBot.define do
  factory :shipping_category, class: Spree::ShippingCategory do
    name { Faker::Name.unique.name }
  end
end
