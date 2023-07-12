require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #search' do
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

    # No Unit tests for Sphinx search calls
  end
end
