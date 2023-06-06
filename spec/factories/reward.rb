FactoryBot.define do
  factory :reward do
    association :rewardable, factory: :question

    name { "BasicRewardNameString" }

    after(:build) do |reward|
      reward.file.attach(
        io: File.open("#{Rails.root}/spec/files/reward1.png"),
        filename: 'reward1.png',
        content_type: 'image/png'
      )
    end

    trait :another do
      name { "AnotherRewardNameString" }

      after(:build) do |reward|
        reward.file.attach(
          io: File.open("#{Rails.root}/spec/files/reward2.png"),
          filename: 'reward2.png',
          content_type: 'image/png'
        )
      end
    end
  end
end
