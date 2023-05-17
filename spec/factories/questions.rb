FactoryBot.define do
  factory :question do
    title { "BasicQuestionTitleString" }
    body { "BasicQuestionBodyText" }
  
    trait :invalid do
      title { nil }
    end

    trait :another do
      title { "AnotherQuestionTitleString" }
      body { "AnotherQuestionBodyText" }
    end

    trait :yet_another do
      title { "YetAnotherQuestionTitleString" }
      body { "YetAnotherQuestionBodyText" }
    end
  end
end
