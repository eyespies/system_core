require 'spec_helper'

describe 'system_core::bash' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      context "On #{platform} #{version}" do
        before do
          Fauxhai.mock(platform: platform, version: version, path: opts['fixture_path']) if opts.key?('fixture_path')
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        it 'should create /etc/profile from a template' do
          expect(chef_run).to create_cookbook_file '/etc/profile'
        end

        it 'should create /etc/profile.d/smiley.sh from a template' do
          expect(chef_run).to create_cookbook_file '/etc/profile.d/smiley.sh'
        end
      end
    end
  end
end
