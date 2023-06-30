shared_examples_for 'API Showable' do
  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let!(:link) { create(:link, linkable: resource) }
    let!(:comment) { create(:comment, commentable: resource) }
  
    before do
      get "/api/v1/#{resource.class.to_s.downcase}s/#{resource.id}",
      params: { id: resource.id, access_token: access_token.token },
      headers: headers
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'return all public resource fields' do
      parameters.each do |attr|
        expect(json["#{resource.class.to_s.downcase}"][attr]).to eq resource.send(attr).as_json
      end
    end

    it 'return all public links fields' do
      %w[id name url linkable_type linkable_id created_at updated_at].each do |attr|
        expect(json["#{resource.class.to_s.downcase}"]['links'].first[attr]).to eq link.send(attr).as_json
      end
    end

    it 'return all public comments fields' do
      %w[id body commentable_type commentable_id user_id created_at updated_at].each do |attr|
        expect(json["#{resource.class.to_s.downcase}"]['comments'].first[attr]).to eq comment.send(attr).as_json
      end
    end

    it 'return files urls' do
      url = Rails.application.routes.url_helpers.rails_blob_url(resource.files.first.blob, host: 'localhost:3000')
      expect(json["#{resource.class.to_s.downcase}"]['files'].first['url']).to eq url
    end
  end
end
