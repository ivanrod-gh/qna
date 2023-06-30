shared_examples_for 'API Authorizable' do
  context 'unathorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(http_method, api_uri, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(http_method, api_uri, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
