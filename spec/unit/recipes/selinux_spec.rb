require 'spec_helper'

describe 'system_core::selinux' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      context "On #{platform} #{version}" do
        before do
          Fauxhai.mock(platform: platform, version: version, path: opts['fixture_path']) if opts.key?('fixture_path')

          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('selinux::permissive')
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        it 'should include the selinux recipes' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('selinux::permissive')
          chef_run
        end
      end
    end
  end
end
