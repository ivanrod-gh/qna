require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {{ "ACCEPT" => "application/json" }}

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :get }
      let(:api_uri) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:http_method) { :get }
      let(:api_uri) { '/api/v1/profiles/all_others' }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let!(:another) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/all_others', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of another users' do
        expect(json['users'].size).to eq 1
      end

      it 'does not contains current user fields' do
        json['users'].each do |user|
          expect(user['id']).not_to eq me.id
        end
      end

      it 'return all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['users'].first[attr]).to eq another.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['users'].first[attr]).not_to eq another.send(attr).as_json
        end
      end
    end
  end
end
