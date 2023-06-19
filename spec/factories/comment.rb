FactoryBot.define do
  factory :comment do
    user
    association :commentable, factory: :question

    body { "BasicCommentBodyText" }

    trait :invalid do
      title { nil }
    end

    trait :another do
      body { "AnotherCommentBodyText" }
    end
  end
end
