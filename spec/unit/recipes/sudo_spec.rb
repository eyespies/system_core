require 'spec_helper'

describe 'system_core::sudo' do
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

        it 'should install sudo packages' do
          expect(chef_run).to install_package('sudo')
        end

        it 'should create the sudo config called "global_sudo"' do
          expect(chef_run).to create_sudo('global_sudo')
        end
      end
    end
  end
end
