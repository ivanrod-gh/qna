class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @resource = Object.const_get(ActiveStorage::Attachment.last.record_type)
                      .find(ActiveStorage::Attachment.last.record_id)
    if @resource.user == current_user
      @attachment.purge
    else
      redirect_to questions_path, notice: "You are not be able to perform this action."
    end
  end
end
