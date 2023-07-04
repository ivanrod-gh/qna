require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let(:service) { double('Services::Subscription') }
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  
  before do
    allow(Services::Subscription).to receive(:new).and_return(service)
  end
  
  it 'call Services::Subscription#send_notify' do
    expect(service).to receive(:send_notify).with(user, question)
    SubscriptionJob.perform_now(user, question)
  end
end
