require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  describe 'POST #create' do
    before { login(user) }

    it 'assign the requested question to @question' do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect do
          post :create,
          params: { question_id: question, answer: attributes_for(:answer) },
          format: :js
        end.to change(Answer, :count).by(1)
      end

      it 'render errors with JS create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect do
          post :create,
          params: { question_id: question, answer: attributes_for(:answer, :invalid) },
          format: :js
        end.not_to change(Answer, :count)
      end

      it 'render errors with JS create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    describe 'if user logged in as an author of an answer and tries to change an answer' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :another) }, format: :js
          answer.reload
          expect(answer.body).to eq attributes_for(:answer, :another)[:body]
        end
        
        it 'updates an answer with JS update' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :another) }, format: :js
          expect(response).to render_template :update
        end
      end
      
      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            answer.reload
          end.to_not change(answer, :body)
        end
      
        it 'render errors with JS update' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :another) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    describe 'if user logged in not as an author of an answer and tries to change an answer' do
      before { login(another_user) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          answer.reload
        end.to_not change(answer, :body)
      end
    
      it 'redirect to current question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }

    describe 'if user logged in as an author of an answer' do
      before { login(user) }

      it 'delete an answer' do
        expect{ delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'deletes an answer from page with JS destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
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

  describe 'POST #best_mark' do
    describe 'if user logged in as an author of an question' do
      before { login(user) }

      let(:another_answer) { create(:answer, :another, user: user, question: question) }

      it 'mark answer as the best answer' do
        expect do
          post :best_mark, params: { id: answer }, format: :js
          answer.reload
        end.to change(answer, :best).from(false).to(true)
      end

      it 'new best marked answer will set old best answer to not be a best answer' do
        post :best_mark, params: { id: another_answer }, format: :js
        another_answer.reload
        expect do
          post :best_mark, params: { id: answer }, format: :js
          another_answer.reload
        end.to change(another_answer, :best).from(true).to(false)
      end
    end

    describe 'if user logged in not as an author of an question' do
      before { login(another_user) }

      it 'does not change answer best field' do
        expect do
          post :best_mark, params: { id: answer }
          answer.reload
        end.not_to change(answer, :best)
      end

      it 'redirect to current question' do
        post :best_mark, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
