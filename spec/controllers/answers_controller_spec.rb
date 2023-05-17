require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:question) { users[0].questions.create(attributes_for(:question)) }
  let(:answer) { question.answers.create(attributes_for(:answer).merge!(user: users[0])) }

  describe 'POST #create' do
    before { login(users[0]) }

    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect{
          post :create,
          params: { question_id: question, answer: attributes_for(:answer) }
        }.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect{
          post :create,
          params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        }.not_to change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(attributes_for(:answer).merge!(user: users[0])) }

    describe 'if user logged in as an author of an answer' do
      before { login(users[0]) }

      it 'delete an answer' do
        expect{ delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to current question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    describe 'if user logged in not as an author of an answer' do
      before { login(users[1]) }

      it 'does not delete the question' do
        expect{ delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it 'redirect to current question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
