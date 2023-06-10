require 'rails_helper'

shared_examples_for "votable" do |votable_table|
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_question) { create(:question, user: another_user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:another_answer) { create(:answer, user: another_user, question: question) }
  let(:votable) { votable_table == "answers" ? answer : question }
  let(:another_votable) { votable_table == "answers" ? another_answer : another_question }

  describe 'POST #like' do
    before { login(user) }

    it 'assign the requested votable to @votable' do
      post :like, params: { id: votable, votable_table: votable_table}, format: :json
      expect(assigns(:votable)).to eq votable
    end

    it 'save a new vote in the database' do
      expect { post :like, params: { id: another_votable, votable_table: votable_table}, format: :json }.to change(Vote, :count).by(1)
    end

    it 'deletes a vote from the database if it already exists' do
      post :like, params: { id: another_votable, votable_table: votable_table}, format: :json
      another_votable.reload
      expect { post :like, params: { id: another_votable, votable_table: votable_table}, format: :json }.to change(Vote, :count).by(-1)
    end

    it 'does nothing if acts author of votable' do
      expect { post :like, params: { id: votable, votable_table: votable_table}, format: :json }.not_to change(Vote, :count)
    end
  end

  describe 'POST #dislike' do
    before { login(user) }

    it 'save a new vote in the database' do
      expect { post :dislike, params: { id: another_votable, votable_table: votable_table}, format: :json }.to change(Vote, :count).by(1)
    end

    it 'deletes a vote from the database if it already exists' do
      post :dislike, params: { id: another_votable, votable_table: votable_table}, format: :json
      another_votable.reload
      expect { post :dislike, params: { id: another_votable, votable_table: votable_table}, format: :json }.to change(Vote, :count).by(-1)
    end

    it 'does nothing if acts author of votable' do
      expect { post :like, params: { id: votable, votable_table: votable_table}, format: :json }.not_to change(Vote, :count)
    end
  end
end

RSpec.describe AnswersController, type: :controller do
  it_behaves_like "votable", "answers"
end

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like "votable", "questions"
end
