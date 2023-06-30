class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :question_id, :user_id, :created_at, :updated_at
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end
