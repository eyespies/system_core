require 'spec_helper'

describe 'system_core::rsyslog' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      context "On #{platform} #{version}" do
        before do
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rsyslog')
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe) do
            runner.resource_collection.insert(Chef::Resource::Service.new('rsyslog', runner.run_context))
          end
        end

        it 'should include the rsyslog recipe' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rsyslog')
          # Nothing here on the service because it is defined but no actions are specified
          chef_run
        end
      end
    end
  end
end
