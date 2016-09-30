require 'spec_helper'

describe '## MailCatcher' do
    describe service('mailcatcher'), :if => os[:family] == 'ubuntu' do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(1025) do
      it { should be_listening }
    end

    describe port(1080) do
      it { should be_listening }
    end
end