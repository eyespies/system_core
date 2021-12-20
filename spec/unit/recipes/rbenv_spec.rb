require 'spec_helper'

describe 'system_core::rbenv' do
  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond
  # to specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      context "On #{platform} #{version}" do
        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, path: opts['fixture_path'])
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        let(:ruby_gems) do
          chef_run.node['system_core']['ruby']['gems']
        end

        let(:ruby_version) do
          chef_run.node['system_core']['ruby']['global']
        end

        it 'should install the bzip package' do
          expect(chef_run).to install_package('bzip2')
        end

        it 'should install the system "rbenv" and the specific ruby version' do
          expect(chef_run).to install_rbenv_system_install('system')
          expect(chef_run).to install_rbenv_ruby(ruby_version)
        end

        it 'should create /root/.gemrc' do
          expect(chef_run).to create_cookbook_file('/root/.gemrc')
        end

        it "Should install the necessary Gems" do
          ruby_gems.each do |gem_name|
            expect(chef_run).to install_rbenv_gem(gem_name)
          end
        end
      end
    end
  end
end
