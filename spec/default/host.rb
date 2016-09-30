require 'spec_helper'

describe '## System' do
    describe host('joomla.box') do
        it { should be_resolvable.by('hosts') }
        its(:ipaddress) { should eq '127.0.1.1' }
    end

    describe host('joomlatools') do
        it { should be_resolvable.by('hosts') }
    end

    describe command('hostname -f') do
        its(:stdout) { should eq "joomlatools\n" }
    end

    describe command('echo $JOOMLATOOLS_BOX') do
        its(:stdout) { should match /\d\.\d\.\d$/ }
    end

    describe command('/sbin/swapon -s') do
        its(:stdout) { should match /\/mnt\/swap\.1\s+file\s+548860/ }
    end
end