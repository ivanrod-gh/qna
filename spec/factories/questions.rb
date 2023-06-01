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
  
    trait :with_attached_file do
      after(:build) do |question|
        question.files.attach(
          io: File.open("#{Rails.root}/spec/files/file1.txt"),
          filename: 'file1.txt',
          content_type: 'text/txt'
        )
      end
    end

    trait :with_two_attached_files do
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

    trait :with_attached_link do
      after(:build) do |question|
        question.links.new(name: 'link1', url: 'https://ya.ru/')
      end
    end

    trait :with_two_attached_links do
      after(:build) do |question|
        question.links.new(name: 'link1', url: 'https://ya.ru/')
        question.links.new(name: 'link2', url: 'https://2ip.ru/')
      end
    end
  end
end
