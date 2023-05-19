FactoryBot.define do
  factory :answer do
    user
    question

    body { "BasicAnswerBodyText" }
    
    trait :invalid do
      body { nil }
    end

    trait :another do
      body { "AnotherAnswerBodyText" }
    end

    trait :another_one do
      body { "AnotherOneAnswerBodyText" }
    end
  end
end
