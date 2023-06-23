require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let!(:questions) do
      5.times { create(:question, user: user) }
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

    it 'assign new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
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

    it 'assigns a new Link to @question.links' do
      expect(assigns(:question).links.first).to be_a_new(Link)
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

  describe 'PATCH #update' do
    describe 'if user logged in as an author of the question and tries to change the question' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes question attributes' do
          patch :update, params: { id: question, question: attributes_for(:question, :another) }, format: :js
          question.reload
          expect(question.body).to eq attributes_for(:question, :another)[:body]
        end
        
        it 'updates the question with JS update' do
          patch :update, params: { id: question, question: attributes_for(:question, :another) }, format: :js
          expect(response).to render_template :update
        end
      end
      
      context 'with invalid attributes' do
        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
            question.reload
          end.not_to change(question, :body)
        end
      
        it 'render errors with JS update' do
          patch :update, params: { id: question, question: attributes_for(:question, :another) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    describe 'if user logged in not as an author of the question and tries to change the question' do
      before { login(another_user) }

      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          question.reload
        end.not_to change(question, :body)
      end
    
      it 'redirect\'s to root path' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    describe 'if user logged in as an author of the question' do
      before { login(user) }

      it 'delete the question' do
        expect{ delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to root path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end

    describe 'if user logged in not as an author of the question' do
      before { login(another_user) }

      it 'does not delete the question' do
        expect{ delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end

      it 'redirect to root path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end
  end
end
