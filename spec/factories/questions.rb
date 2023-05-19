FactoryBot.define do
  factory :question do
    user

    title { "BasicQuestionTitleString" }
    body { "BasicQuestionBodyText" }
  
    trait :invalid do
      title { nil }
    end

    trait :another do
      title { "AnotherQuestionTitleString" }
      body { "AnotherQuestionBodyText" }
    end

    trait :another_one do
      title { "AnotherOneQuestionTitleString" }
      body { "AnotherOneQuestionBodyText" }
    end
  end
end
