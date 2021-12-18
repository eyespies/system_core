require 'spec_helper'

describe 'system_core::default' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      context "On #{platform} #{version}" do
        before do
          recipes.each do |recipe|
            allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with(recipe)
          end
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, path: opts['fixture_path'])
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end
      end
    end
  end
end
