require 'mailer/workers/user_workers/confirmation_worker'

RSpec.describe Workers::UserWorkers::ActivationWorker do
  let(:email) { 'user@example.com' }
  let(:confirmation_link) { 'domain.com' }
  let(:message) { { email: email, confirmation_link: confirmation_link }.to_json }

  context 'when in production environment' do
    before do
      expect(Mailer::Env).to receive(:production?) { true }
    end

    it 'should send mail' do
      mail = Mail.new
      expect(Mail).to receive(:new) { mail }
      expect(mail).to receive(:deliver)
  
      subject.work message
  
      expect(mail.to).to include email
      expect(mail.from).to include Mailer::Env.app_email
      expect(mail.subject).to include 'confirmation'
      expect(mail.html_part.body.raw_source).to include confirmation_link
    end
  end

  context 'when not in production environment' do
    before do
      expect(Mailer::Env).to receive(:production?) { false }
    end

    it 'should not send mail' do
      expect(Mail).not_to receive(:new)
  
      subject.work message
    end
  end
end
