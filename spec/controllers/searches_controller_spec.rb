require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do
  let(:user) { create(:user, email: 'some_user@test.com') }
  let(:question) { create(:question, title: 'question with some_query string in title') }
  let(:question_author) { create(:question, title: 'some_query', user: user) }
  let(:question_body) { create(:question, body: 'question with some_query string in body') }
  let(:answer) { create(:answer, body: 'answer with some_query string in body') }
  let(:answer_author) { create(:answer, body: 'answer with some_query string in body', user: user) }
  let(:comment) { create(:comment, body: 'comment with some_query string in body') }
  let(:comment_author) { create(:comment, body: 'comment with some_query string in body', user: user) }
  let(:sphinx_start) do
    ThinkingSphinx::Test.index
    ThinkingSphinx::Test.start
  end
  let(:sphinx_stopt) do
    ThinkingSphinx::Test.stop
  end

  describe 'GET #search' do
    describe 'variables' do
      before { post :search, params: { query: 'some_query%', author: 'some_user' }, format: :js }

      it 'assigns query string to @keyword' do
        expect(assigns(:keyword)).to eq subject.params[:query]
      end

      it 'assigns author string to @author' do
        expect(assigns(:author)).to eq subject.params[:author]
      end

      it 'assigns restricted chars to @restricted_chars if any' do
        expect(assigns(:restricted_chars)).to eq '%'
      end
    end

    describe 'resources', sphinx: true do
      after do
        sphinx_stopt
      end

      it 'find question by title' do
        question
        sphinx_start
        post :search, params: { query: 'some_query', author: '', questions: '1' }, format: :js
        expect(assigns(:result).first).to eq question
      end

      it 'find question by body' do
        question_body
        sphinx_start
        post :search, params: { query: 'some_query', author: '', questions: '1' }, format: :js
        expect(assigns(:result).first).to eq question_body
      end

      it 'find question by title and author' do
        question_author
        sphinx_start
        post :search, params: { query: 'some_query', author: 'some_user', questions: '1' }, format: :js
        expect(assigns(:result).first).to eq question_author
      end

      it 'find answer by body' do
        answer
        sphinx_start
        post :search, params: { query: 'some_query', author: '', answers: '1' }, format: :js
        expect(assigns(:result).first).to eq answer
      end

      it 'find answer by body and author' do
        answer_author
        sphinx_start
        post :search, params: { query: 'some_query', author: 'some_user', answers: '1' }, format: :js
        expect(assigns(:result).first).to eq answer_author
      end

      it 'find comment by body' do
        comment
        sphinx_start
        post :search, params: { query: 'some_query', author: '', comments: '1' }, format: :js
        expect(assigns(:result).first).to eq comment
      end

      it 'find comment by body and author' do
        comment_author
        sphinx_start
        post :search, params: { query: 'some_query', author: 'some_user', comments: '1' }, format: :js
        expect(assigns(:result).first).to eq comment_author
      end

      it 'find nothing if query size less than SearchesController::CHARACTERS_MINIMUM_COUNT' do
        question
        sphinx_start
        post :search, params: { query: 'so', author: '', questions: '1' }, format: :js
        expect(assigns(:result)).to eq nil
      end

      it 'find nothing if query contains restricted characters' do
        question
        sphinx_start
        post :search, params: { query: 'some_query&', author: '', questions: '1' }, format: :js
        expect(assigns(:result)).to eq nil
      end
    end
  end
end
