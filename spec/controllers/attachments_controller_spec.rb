require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'DELETE #destroy' do
    describe 'if record type is question' do
      let!(:question_with_attached_file) { create(:question, :with_attached_file, user: user) }

      describe 'and user logged in as an author of the question' do
        before { login(user) }

        it 'delete the attachment' do
          expect do
            delete :destroy, params: { id: question_with_attached_file.files.first }, format: :js
          end.to change(ActiveStorage::Attachment, :count).by(-1)
        end
      end

      describe 'and user logged in not as an author of the question' do
        before { login(another_user) }

        it 'does not delete the attachment' do
          expect do
            delete :destroy, params: { id: question_with_attached_file.files.first }, format: :js
          end.to change(ActiveStorage::Attachment, :count).by(0)
        end

        it 'redirect to root path' do
          delete :destroy, params: { id: question_with_attached_file.files.first }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'if record type is answer' do
      let!(:answer_with_attached_file) { create(:answer, :with_attached_file, user: user) }

      describe 'and user logged in as an author of the answer' do
        before { login(user) }

        it 'delete the attachment' do
          expect do
            delete :destroy, params: { id: answer_with_attached_file.files.first }, format: :js
          end.to change(ActiveStorage::Attachment, :count).by(-1)
        end
      end

      describe 'and user logged in not as an author of the answer' do
        before { login(another_user) }

        it 'does not delete the attachment' do
          expect do
            delete :destroy, params: { id: answer_with_attached_file.files.first }, format: :js
          end.to change(ActiveStorage::Attachment, :count).by(0)
        end

        it 'redirect to root path' do
          delete :destroy, params: { id: answer_with_attached_file.files.first }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
