require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let!(:questions) { create_list(:question, 5) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let!(:question) { create(:question) }
    before { get :show, params: { id: question } }
    
    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    
    it 'render show view' do
      expect(response).to render_template :show
    end
  end
end
