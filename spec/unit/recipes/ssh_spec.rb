require 'spec_helper'

describe 'system_core::ssh' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      context "On #{platform} #{version}" do
        before do
          Fauxhai.mock(platform: platform, version: version, path: opts['fixture_path']) if opts.key?('fixture_path')

          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openssh')
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        it 'should include the necessary dependent recipes' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openssh')
          chef_run
        end

        it 'should create the SSH banner' do
          expect(chef_run).to create_template('/etc/ssh/banner')
          expect(chef_run).to_not create_group('sshusers')
        end
      end
    end
  end
end
