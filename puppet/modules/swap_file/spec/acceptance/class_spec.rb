require 'spec_helper_acceptance'

describe 'swap_file class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do

  context 'swap_file' do
    context 'ensure => present' do
      it 'should work with no errors' do
        pp = <<-EOS
        class { 'swap_file': }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes  => true)
      end
      it 'should contain the default swapfile' do
        shell('/sbin/swapon -s | grep /mnt/swap.1', :acceptable_exit_codes => [0])
      end
      it 'should contain the default fstab setting' do
        shell('cat /etc/fstab | grep /mnt/swap.1', :acceptable_exit_codes => [0])
        shell('cat /etc/fstab | grep defaults', :acceptable_exit_codes => [0])
      end
    end
    context 'custom parameters' do
      it 'should work with no errors' do
        pp = <<-EOS
        class { 'swap_file':
          swapfile => '/tmp/swapfile',
          swapfilesize => '5 MB',
        }
        EOS

        apply_manifest(pp, :catch_failures => true)
        apply_manifest(pp, :catch_changes  => true)
      end
      it 'should contain the given swapfile' do
        shell('/sbin/swapon -s | grep /tmp/swapfile', :acceptable_exit_codes => [0])
        shell('/sbin/swapon -s | grep 5116', :acceptable_exit_codes => [0])
      end
      it 'should contain the default fstab setting' do
        shell('cat /etc/fstab | grep /tmp/swapfile', :acceptable_exit_codes => [0])
        shell('cat /etc/fstab | grep defaults', :acceptable_exit_codes => [0])
      end
    end
  end
end