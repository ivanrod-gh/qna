# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @resource = @attachment.record
    if @resource.user == current_user
      @attachment.purge
    else
      redirect_to questions_path, notice: "You are not be able to perform this action."
    end
  end
end
