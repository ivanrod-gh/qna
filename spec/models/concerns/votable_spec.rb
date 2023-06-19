require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }
end

RSpec.describe Answer, type: :model do
  it_behaves_like "votable"
end

RSpec.describe Question, type: :model do
  it_behaves_like "votable"
end
