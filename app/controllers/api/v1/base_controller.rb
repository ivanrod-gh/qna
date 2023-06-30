# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!

      protect_from_forgery with: :null_session

      private

      def current_resource_user
        @current_resource_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def current_user
        current_resource_user
      end
    end
  end
end
