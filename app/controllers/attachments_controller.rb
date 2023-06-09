# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @attachment
    @attachment.purge
  end
end
