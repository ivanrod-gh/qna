shared_examples_for 'API Deletable' do
  context 'authorized' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before do
      delete "/api/v1/#{resource.class.to_s.downcase}s/#{resource.id}",
      params: {
        access_token: access_token.token,
        id: resource.id
      },
      headers: headers
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'destroys resource' do
      expect(model.count).to eq 0
    end
  end
end



