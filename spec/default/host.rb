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

    describe fstab do
      it do
         should have_entry(
            :device => '/mnt/swap.1',
            :mount_point => '/mnt/swap.1',
            :type => 'swap'
         )
       end
    end
end