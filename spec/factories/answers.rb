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
  
    trait :with_attach do
      after(:build) do |question|
        question.files.attach(
          io: File.open("#{Rails.root}/spec/files/file1.txt"),
          filename: 'file1.txt',
          content_type: 'text/txt'
        )
      end
    end

    trait :with_two_attaches do
      after(:build) do |question|
        question.files.attach(
          io: File.open("#{Rails.root}/spec/files/file1.txt"),
          filename: 'file1.txt',
          content_type: 'text/txt'
        )
        question.files.attach(
          io: File.open("#{Rails.root}/spec/files/file2.txt"),
          filename: 'file2.txt',
          content_type: 'text/txt'
        )
      end
    end
  end
end
