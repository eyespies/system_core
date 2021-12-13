require 'spec_helper'

describe 'system_core::rsyslog' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      context "On #{platform} #{version}" do
        before do
          Fauxhai.mock(platform: platform, version: version, path: opts['fixture_path']) if opts.key?('fixture_path')

          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rsyslog')
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe) do
            runner.resource_collection.insert(Chef::Resource::Service.new('rsyslog', runner.run_context))
          end
        end

        it 'should include the rsyslog recipe and define the rsyslog service' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rsyslog')
          # Nothing here on the service because it is defined but no actions are specified
          resource = chef_run.service('rsyslog')
          expect(resource).to do_nothing
        end
      end
    end
  end
end
