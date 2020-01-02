require 'spec_helper'

describe '## Ruby' do

    let(:sudo_options) { '-u vagrant -i' }

    describe command("ruby --version") do
      its(:stdout) { should match '2.6.5' }
    end

    describe file("/etc/profile.d/rbenv.sh") do
        it { should exist }
        its(:content) { should match 'rbenv init' }
    end

end