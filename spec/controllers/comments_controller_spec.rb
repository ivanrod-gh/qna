require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let(:questions_comment) { create(:comment, user: user, commentable: question) }
  let(:answers_comment) { create(:comment, user: user, commentable: answer) }

  describe 'DELETE #destroy' do
    describe 'if record type is question' do
      before { questions_comment }

      describe 'and user logged in as an author of the question' do
        before { login(user) }

        it 'delete the attachment' do
          expect do
            delete :destroy, params: { id: questions_comment }, format: :js
          end.to change(Comment, :count).by(-1)
        end
      end

      describe 'and user logged in not as an author of the question' do
        before { login(another_user) }

        it 'does not delete the attachment' do
          expect do
            delete :destroy, params: { id: questions_comment }, format: :js
          end.to change(Comment, :count).by(0)
        end

        it 'redirect to root path' do
          delete :destroy, params: { id: questions_comment }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'if record type is answer' do
      before { answers_comment }

      describe 'and user logged in as an author of the question' do
        before { login(user) }

        it 'delete the attachment' do
          expect do
            delete :destroy, params: { id: answers_comment }, format: :js
          end.to change(Comment, :count).by(-1)
        end
      end

      describe 'and user logged in not as an author of the question' do
        before { login(another_user) }

        it 'does not delete the attachment' do
          expect do
            delete :destroy, params: { id: answers_comment }, format: :js
          end.to change(Comment, :count).by(0)
        end

        it 'redirect to root path' do
          delete :destroy, params: { id: answers_comment }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
