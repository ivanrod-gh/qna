require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{ "ACCEPT" => "application/json" }}

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :get }
      let(:api_uri) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
    
      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'return all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :get }
      let(:api_uri) { '/api/v1/questions/1' }
    end

    it_behaves_like 'API Showable' do
      let(:resource) { create(:question, :with_attached_file) }
      let(:parameters) { %w[id title body user_id created_at updated_at] }
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :post }
      let(:api_uri) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        post "/api/v1/questions",
        params: { access_token: access_token.token, title: 'test title', body: 'test body' },
        headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'creates question' do
        expect(Question.count).to eq 1
        expect(Question.last.user_id).to eq me.id
        expect(Question.last.title).to eq 'test title'
        expect(Question.last.body).to eq 'test body'
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :put }
      let(:api_uri) { '/api/v1/questions/1' }
    end

    it_behaves_like 'API Updatable' do
      let(:model) { Question }
      let(:resource) { create(:question, user: me) }
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :delete }
      let(:api_uri) { '/api/v1/questions/1' }
    end

    it_behaves_like 'API Deletable' do
      let(:model) { Question }
      let(:resource) { create(:question, user: me) }
    end
  end
end
