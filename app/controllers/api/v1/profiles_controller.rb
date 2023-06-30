# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def me
        authorize! :me, User
        render json: current_resource_user, serializer: UserSerializer
      end

      def all_others
        authorize! :all_others, User
        render json: User.all.where.not(id: current_resource_user.id), each_serializer: UserSerializer
      end
    end
  end
end
