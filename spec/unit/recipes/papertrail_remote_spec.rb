require 'spec_helper'

describe 'system_core::papertrail_remote' do
  packages = {
    'centos' => {
      'remote_syslog2' => '/tmp/remote_syslog2.rpm'
    },
    'oracle' => {
      'remote_syslog2' => '/tmp/remote_syslog2.rpm'
    }
  }

  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond to
  # specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      context "On #{platform} #{version} with papertrail enabled" do
        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, file_cache_path: '/tmp')
          runner.node.override['environment'] = 'dev'
          runner.node.override['system_core']['papertrail']['enabled'] = true
          runner.node.override['system_core']['papertrail']['remote_host'] = '@@logs.papertrailapp.com:12345'
          runner.node.override['system_core']['papertrail']['remote_syslog2']['config']['file_name'] = '/etc/remote_syslog.conf'
          runner.node.override['system_core']['papertrail']['remote_syslog2']['hostname'] = 'test-hostname'
          runner.node.override['system_core']['papertrail']['remote_syslog2']['files'] = { '/etc/file1' => 'tag1',
                                                                                           '/etc/file2' => nil }
          runner.node.override['system_core']['papertrail']['remote_syslog2']['exclude_patterns'] = ['*pattern1*']

          runner.converge(described_recipe)
          # do
          #   runner.resource_collection.insert(Chef::Resource::Service.new(packages[platform][''], runner.run_context))
          # end
        end

        it "should download and install the #{packages[platform]['remote_syslog2']} package" do
          expect(chef_run).to create_remote_file('/tmp/remote_syslog2.rpm')
          expect(chef_run).to install_package packages[platform]['remote_syslog2']
        end

        it 'should create the remote_syslog configuration file' do
          expect(chef_run).to create_template('/etc/remote_syslog.conf')
        end

        it 'should start and enable the remote_syslog service' do
          expect(chef_run).to start_service('remote-syslog')
          expect(chef_run).to enable_service('remote-syslog')
        end

        it 'should not display a log message at the warning level' do
          expect(chef_run).to_not write_log('papertrail-disabled')
        end
      end

      context "On #{platform} #{version} with papertrail disabled" do
        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, file_cache_path: '/tmp')
          runner.node.override['environment'] = 'dev'
          runner.node.override['system_core']['papertrail']['enabled'] = false
          runner.node.override['system_core']['papertrail']['remote_syslog2']['config']['file_name'] = '/etc/remote_syslog.conf'
          runner.converge(described_recipe)
          # do
          #   runner.resource_collection.insert(Chef::Resource::Service.new(packages[platform][''], runner.run_context))
          # end
        end

        it "should not download and install the #{packages[platform]['remote_syslog2']} package" do
          expect(chef_run).to_not create_remote_file('/tmp/remote_syslog2.rpm')
          expect(chef_run).to_not install_package packages[platform]['remote_syslog2']
        end

        it 'should not create the remote_syslog configuration file' do
          expect(chef_run).to_not create_template('/etc/remote_syslog.conf')
        end

        it 'should start and enable the remote_syslog service' do
          expect(chef_run).to_not start_service('remote-syslog')
          expect(chef_run).to_not enable_service('remote-syslog')
        end

        it 'should display a log message at the warning level' do
          expect(chef_run).to write_log('papertrail-disabled').with(level: :warn)
        end
      end
    end
  end
end
