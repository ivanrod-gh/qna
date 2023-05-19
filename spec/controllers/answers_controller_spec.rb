require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  describe 'POST #create' do
    before { login(user) }

    it 'assign the requested question to @question' do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
      expect(assigns(:question)).to eq question
    end

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
    let!(:answer) { create(:answer, user: user, question: question) }

    describe 'if user logged in as an author of an answer' do
      before { login(user) }

      it 'delete an answer' do
        expect{ delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to current question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    describe 'if user logged in not as an author of an answer' do
      before { login(another_user) }

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
