require 'spec_helper'

describe '## NodeJS' do

    describe package('nodejs'), :if => os[:family] == 'ubuntu' do
      it { should be_installed }
    end

    describe command('npm -g list uglify-js') do
      its(:exit_status) { should eq 0}
    end

    describe command('npm -g list less') do
      its(:exit_status) { should eq 0}
    end

    describe command('npm -g list yellowlabtools') do
      its(:exit_status) { should eq 0}
    end

end