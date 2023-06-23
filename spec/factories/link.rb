FactoryBot.define do
  factory :link do
    association :linkable, factory: :question

    name { "BasicLinkNameString" }
    url { "https://rspec.info" }
  end
end
