require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{ "ACCEPT" => "application/json" }}

  describe 'GET /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :get }
      let(:api_uri) { '/api/v1/questions/1/answers' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer_response) { json['answers'].first }
    
      before do
        get "/api/v1/questions/#{question.id}/answers",
        params: { access_token: access_token.token },
        headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'return all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :get }
      let(:api_uri) { '/api/v1/answers/1' }
    end


    it_behaves_like 'API Showable' do
      let(:resource) { create(:answer, :with_attached_file) }
      let(:parameters) { %w[id body user_id created_at updated_at] }
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :post }
      let(:api_uri) { '/api/v1/questions/1/answers' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:question) { create(:question, user: me) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        post "/api/v1/questions/#{question.id}/answers",
        params: { access_token: access_token.token, question_id: question.id, body: 'test body' },
        headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'creates answer' do
        expect(Answer.count).to eq 1
        expect(Answer.last.user_id).to eq me.id
        expect(Answer.last.body).to eq 'test body'
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :put }
      let(:api_uri) { '/api/v1/answers/1' }
    end

    it_behaves_like 'API Updatable' do
      let(:model) { Answer }
      let(:resource) { create(:answer, user: me) }
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :delete }
      let(:api_uri) { '/api/v1/answers/1' }
    end

    it_behaves_like 'API Deletable' do
      let(:model) { Answer }
      let(:resource) { create(:answer, user: me) }
    end
  end
end
