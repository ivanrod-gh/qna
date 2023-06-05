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
  
    trait :with_attached_file do
      after(:build) do |answer|
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/files/file1.txt"),
          filename: 'file1.txt',
          content_type: 'text/txt'
        )
      end
    end

    trait :with_two_attached_files do
      after(:build) do |answer|
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/files/file1.txt"),
          filename: 'file1.txt',
          content_type: 'text/txt'
        )
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/files/file2.txt"),
          filename: 'file2.txt',
          content_type: 'text/txt'
        )
      end
    end

    trait :with_attached_link do
      after(:build) do |answer|
        answer.links.new(name: 'link1', url: 'https://ya.ru/')
      end
    end

    trait :with_two_attached_links do
      after(:build) do |answer|
        answer.links.new(name: 'link1', url: 'https://ya.ru/')
        answer.links.new(name: 'link2', url: 'https://2ip.ru/')
      end
    end

    trait :with_attached_gist_link do
      after(:build) do |answer|
        answer.links.new(name: 'gist link', url: 'https://gist.github.com/ivanrod-gh/da32151556476ce4cbebd5d0c0c2acbe')
      end
    end
  end
end
