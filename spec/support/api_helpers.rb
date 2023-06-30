module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(http_method, api_uri, options = {})
    if options.key?(:params)
      send http_method, api_uri, headers: options[:headers], params: options[:params]
    elsif options.keys.count > 0
      send http_method, api_uri, headers: options[:headers]
    end
  end
end
