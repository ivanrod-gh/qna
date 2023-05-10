FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
  
    trait :invalid do
      title { nil }
    end

    trait :another do
      title { "AnotherString" }
      body { "AnotherText" }
    end
  end
end
