require 'spec_helper'

describe 'system_core::postfix' do
  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond to
  # specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      context "On #{platform} #{version}" do
        before do
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('postfix')
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        it 'should include the postfix::default recipe' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('postfix')

          # Not checking for any actions on the rsyslog service because it is declared but no action is taken
          chef_run
        end
      end
    end
  end
end
