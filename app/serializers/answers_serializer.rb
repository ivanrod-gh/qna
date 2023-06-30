class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :question_id, :user_id, :created_at, :updated_at
end
