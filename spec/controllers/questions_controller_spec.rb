require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { user.questions.create(attributes_for(:question)) }

  describe 'GET #index' do
    let!(:questions) do
      5.times { user.questions.create(attributes_for(:question)) }
      user.questions
    end
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }
    
    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    
    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }
    
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect{ post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect{ post :create, params: { question: attributes_for(:question, :invalid) } }.not_to change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :another) }}

      it 'assign the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        question.reload

        expect(question.title).to eq attributes_for(:question, :another)[:title]
        expect(question.body).to eq attributes_for(:question, :another)[:body]
      end

      it 'redirects to updated_question' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }}

      it 'does not change question' do
        question.reload

        expect(question.title).to eq attributes_for(:question)[:title]
        expect(question.body).to eq attributes_for(:question)[:body]
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { user.questions.create(attributes_for(:question)) }

    it 'delete the question' do
      expect{ delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
