FactoryBot.define do
  factory :answer do
    body { "AnswerBodyText" }
    
    trait :invalid do
      body { nil }
    end

    trait :another do
      body { "AnotherAnswerBodyText" }
    end

    trait :yet_another do
      body { "YetAnotherAnswerBodyText" }
    end
  end
end
