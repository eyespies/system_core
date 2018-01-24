require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe 'system_core::papertrail' do
  packages = {
    'centos' => {
      'gnutls-package' => 'rsyslog-gnutls',
      'rsyslog-service' => 'rsyslog'
    },
    'oracle' => {
      'gnutls-package' => 'rsyslog-gnutls',
      'rsyslog-service' => 'rsyslog'
    }
  }

  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond to
  # specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      context "On #{platform} #{version} with papertrail enabled" do
        before do
          # Mock accepting the include_recipe commands
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('system_core::rsyslog')
          stub_command("test -e /etc/init.d/td-agent").and_return(true)
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe) do
            runner.resource_collection.insert(Chef::Resource::Service.new(packages[platform]['rsyslog-service'], runner.run_context))
          end
        end

        it 'should reference the rsyslog cookbook' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('system_core::rsyslog')
          chef_run
        end

        it "should install the #{packages[platform]['gnutls-package']} package and notify the #{packages[platform]['rsyslog-service']} service" do
          expect(chef_run).to install_package packages[platform]['gnutls-package']

          package = chef_run.package(packages[platform]['gnutls-package'])
          expect(package).to notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it "should create the rsyslog spool directory and notify the #{packages[platform]['rsyslog-service']} service" do
          expect(chef_run).to create_directory '/var/spool/rsyslog'

          dir = chef_run.directory('/var/spool/rsyslog')
          expect(dir).to notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it "Should create the Papertrail SSL PEM bundle and notify the #{packages[platform]['rsyslog-service']} service" do
          expect(chef_run).to create_cookbook_file '/etc/papertrail-bundle.pem'

          file = chef_run.cookbook_file('/etc/papertrail-bundle.pem')
          expect(file).to notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it "Should create the Papertrail custom rsyslog configuration and notify the #{packages[platform]['rsyslog-service']} service" do
          expect(chef_run).to create_cookbook_file '/etc/rsyslog.d/22-papertrail.conf'

          file = chef_run.cookbook_file('/etc/rsyslog.d/22-papertrail.conf')
          expect(file).to notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it 'should delete any existing loggly configuration' do
          expect(chef_run).to delete_file '/etc/rsyslog.d/22-loggly.conf'
        end

        # TODO: This is only true if /etc/init.d/td-agent exists
        it 'should stop the existing TreasureData agent' do
          expect(chef_run).to stop_service 'td-agent'
          expect(chef_run).to disable_service 'td-agent'
        end

        it 'should not display a log message at the warning level' do
          expect(chef_run).to_not write_log('papertrail-disabled')
        end
      end

      context "On #{platform} #{version} with papertrail disabled" do
        before do
          # Mock accepting the include_recipe commands
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('system_core::rsyslog')
          stub_command("test -e /etc/init.d/td-agent").and_return(true)
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.node.override['system_core']['papertrail']['enabled'] = false
          runner.converge(described_recipe) do
            runner.resource_collection.insert(Chef::Resource::Service.new(packages[platform]['rsyslog-service'], runner.run_context))
          end
        end

        it 'should not reference the rsyslog cookbook' do
          expect_any_instance_of(Chef::Recipe).to_not receive(:include_recipe).with('system_core::rsyslog')
          chef_run
        end

        it "should not install the #{packages[platform]['gnutls-package']} package and notify the #{packages[platform]['rsyslog-service']} service" do
          expect(chef_run).to_not install_package packages[platform]['gnutls-package']

          package = chef_run.package(packages[platform]['gnutls-package'])
          expect(package).to_not notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it "should not create the rsyslog spool directory and notify the #{packages[platform]['rsyslog-service']} service" do
          expect(chef_run).to_not create_directory '/var/spool/rsyslog'

          dir = chef_run.directory('/var/spool/rsyslog')
          expect(dir).to_not notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it "Should not create the Papertrail SSL PEM bundle and notify the #{packages[platform]['rsyslog-service']} service" do
          expect(chef_run).to_not create_cookbook_file '/etc/papertrail-bundle.pem'

          file = chef_run.cookbook_file('/etc/papertrail-bundle.pem')
          expect(file).to_not notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it "Should not create the Papertrail custom rsyslog configuration and notify the #{packages[platform]['rsyslog-service']} service" do
          expect(chef_run).to_not create_cookbook_file '/etc/rsyslog.d/22-papertrail.conf'

          file = chef_run.cookbook_file('/etc/rsyslog.d/22-papertrail.conf')
          expect(file).to_not notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it 'should not delete any existing loggly configuration' do
          expect(chef_run).to_not delete_file '/etc/rsyslog.d/22-loggly.conf'
        end

        # TODO: This is only true if /etc/init.d/td-agent exists
        it 'should not stop the existing TreasureData agent' do
          expect(chef_run).to_not stop_service 'td-agent'
          expect(chef_run).to_not disable_service 'td-agent'
        end

        it 'should display a log message at the warning level' do
          expect(chef_run).to write_log('papertrail-disabled').with(level: :warn)
        end
      end
    end
  end
end
