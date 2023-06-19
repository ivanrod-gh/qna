require 'rails_helper'

shared_examples_for "commentable" do
  it { should have_many(:comments).dependent(:destroy) }
end

RSpec.describe Answer, type: :model do
  it_behaves_like "commentable"
end

RSpec.describe Question, type: :model do
  it_behaves_like "commentable"
end
