require 'spec_helper'

rvm_default_ruby = 'ruby-2.5.1'

describe '## Ruby' do

    let(:sudo_options) { '-u vagrant -i' }

    describe command("ruby --version") do
      its(:stdout) { should match rvm_default_ruby.split('-')[-1].to_s }
    end

end