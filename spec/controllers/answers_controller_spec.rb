require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'before action' do
    it 'find question and assigns it to @question' do
      get :new, params: { question_id: question }
      expect(assigns(:question)).to eq Question.find(question.id)
    end
  end

  describe 'GET #new' do
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
    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect{
          post :create,
          params: { question_id: question, answer: attributes_for(:answer) }
        }.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:answer)
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
end
