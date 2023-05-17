require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'before action' do
    before { login(user) }

    it 'find question and assigns it to @question' do
      get :new, params: { question_id: question }
      expect(assigns(:question)).to eq Question.find(question.id)
    end
  end

  describe 'GET #new' do
    before { login(user) }

    it 'assign new answer to @answer' do
      get :new, params: { question_id: question }
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'new answer linked to it\'s question' do
      get :new, params: { question_id: question }
      expect(assigns(:answer)).to have_attributes question_id: question.id
    end

    it 'render new view' do
      get :new, params: { question_id: question }
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

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
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let(:question) { create(:question) }
    let!(:answer) { question.answers.push(Answer.new(attributes_for(:answer))) }

    it 'delete an answer' do
      expect{ delete :destroy, params: { id: answer[0] } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to current question' do
      delete :destroy, params: { id: answer[0] }
      expect(response).to redirect_to question_path(question)
    end
  end
end
