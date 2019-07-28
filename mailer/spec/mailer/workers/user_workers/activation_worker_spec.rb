require 'mailer/workers/user_workers/activation_worker'

RSpec.describe Workers::UserWorkers::ActivationWorker do
  let(:email) { 'lucas.winningham@gmail.com' }
  let(:activation_link) { 'domain.com' }
  let(:message) { { email: email, activation_link: activation_link }.to_json }

  context 'when in production environment' do
    before do
      expect(Mailer::Env).to receive(:production?) { true }
    end

    it 'should send email' do
      mail = Mail.new
      expect(Mail).to receive(:new) { mail }
      expect(mail).to receive(:deliver)
  
      subject.work message
  
      expect(mail.to).to include email
      expect(mail.from).to include Mailer::Env.app_email
      expect(mail.subject).to include 'activation'
      expect(mail.html_part.body.raw_source).to include activation_link
    end
  end

  context 'when not in production environment' do
    before do
      expect(Mailer::Env).to receive(:production?) { false }
    end

    it 'should not send email' do
      expect(Mail).not_to receive(:new)
  
      subject.work message
    end
  end
end
