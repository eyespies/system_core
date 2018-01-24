# encoding: utf-8

# author: Justin Spies
require 'spec_helper'

describe 'Install and configure rbenv' do
  describe package('bzip2') do
    it { should be_installed }
  end

  %w[rbenv/bin rbenv/completions rbenv/src rbenv/rbenv.d rbenv/libexec rbenv/test].each do |dir|
    describe file("/usr/local/#{dir}") do
      it { should be_directory }
      it { should be_owned_by('root') }
      it { should be_grouped_into('root') }
      # According to the documentation, we should be able to use something like '2775', but
      # that doesn't work for some reason.
      it { should be_mode('755') }
    end
  end

  # Check for the current default version of Ruby
  # NOTE: to run this as root using sudo, it is necessary to use "sudo su - -c 'rbenv versions'" because
  # sudo itself cannot find the rbenv command
  describe command('source ~/.bashrc && rbenv version') do
    its(:stdout) { should match(/^\s*system/) }
    its(:stderr) { should eq '' }
    its(:exit_status) { should eq 0 }
  end

  # Check the list of all installed versions of Ruby
  describe command('source ~/.bashrc && rbenv versions') do
    its(:stdout) { should match(/^\s*2.2.2/) }
    its(:stderr) { should eq '' }
    its(:exit_status) { should eq 0 }
  end
end

describe 'Install the Ruby plugins' do
  %w[rbenv rbenv/plugins rbenv/versions].each do |dir|
    file("/usr/local/#{dir}") do
      it { should be_directory }
      it { should be_owned_by('root') }
      it { should be_grouped_into('root') }
      # According to the documentation, we should be able to use something like '2775', but
      # that doesn't work for some reason.
      it { should be_mode('755') }
    end
  end
end
