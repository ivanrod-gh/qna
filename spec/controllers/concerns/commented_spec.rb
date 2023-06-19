require 'rails_helper'

shared_examples_for "commented" do |table|
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:commentable) { table == "answers" ? answer : question }

  describe 'POST #comment' do
    before { login(user) }

    it 'assign the requested commentable to @commentable' do
      post :comment, params: { id: commentable, comment: attributes_for(:comment), table: table }, format: :json
      expect(assigns(:commentable)).to eq commentable
    end

    it 'save a new comment in the database' do
      expect do
          post :comment,
          params: { id: commentable, comment: attributes_for(:comment), table: table },
          format: :json
      end.to change(Comment, :count).by(1)
    end
  end
end

RSpec.describe AnswersController, type: :controller do
  it_behaves_like "commented", "answers"
end

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like "commented", "questions"
end
