class FileSerializer < ActiveModel::Serializer
  attributes :url

  def url
    Rails.application.routes.url_helpers.rails_blob_url(object.blob, host: 'localhost:3000')
  end
end
