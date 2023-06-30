shared_examples_for 'API Updatable' do
  context 'authorized' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before do
      put "/api/v1/#{resource.class.to_s.downcase}s/#{resource.id}",
      params: {
        access_token: access_token.token,
        id: resource.id,
        body: 'test body updated'
      },
      headers: headers
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it "updates resource" do
      expect(model.last.body).to eq 'test body updated'
    end
  end
end
