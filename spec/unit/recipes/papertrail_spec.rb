require 'spec_helper'

describe 'system_core::papertrail' do
  packages = {
    'ubuntu' => {
      'gnutls-package' => 'rsyslog-gnutls',
      'rsyslog-service' => 'rsyslog',
    },
    'centos' => {
      'gnutls-package' => 'rsyslog-gnutls',
      'rsyslog-service' => 'rsyslog',
    },
    'oracle' => {
      'gnutls-package' => 'rsyslog-gnutls',
      'rsyslog-service' => 'rsyslog',
    },
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
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.node.override['system_core']['papertrail']['enabled'] = true
          runner.converge(described_recipe) do
            runner.resource_collection.insert(Chef::Resource::Service.new(packages[platform]['rsyslog-service'], runner.run_context))
          end
        end

        it 'should run the rsyslog cookbook' do
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
          expect(chef_run).to create_template '/etc/rsyslog.d/22-papertrail.conf'

          file = chef_run.template('/etc/rsyslog.d/22-papertrail.conf')
          expect(file).to notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it 'should not display a log message at the warning level' do
          expect(chef_run).to_not write_log('papertrail-disabled')
        end
      end

      context "On #{platform} #{version} with papertrail disabled" do
        before do
          # Mock accepting the include_recipe commands
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('system_core::rsyslog')
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.node.override['system_core']['papertrail']['enabled'] = false
          runner.converge(described_recipe) do
            runner.resource_collection.insert(Chef::Resource::Service.new(packages[platform]['rsyslog-service'], runner.run_context))
          end
        end

        it 'should not run the rsyslog cookbook' do
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
          expect(chef_run).to_not create_template '/etc/rsyslog.d/22-papertrail.conf'

          file = chef_run.template('/etc/rsyslog.d/22-papertrail.conf')
          expect(file).to_not notify("service[#{packages[platform]['rsyslog-service']}]").to(:restart).delayed
        end

        it 'should display a log message at the warning level' do
          expect(chef_run).to write_log('papertrail-disabled').with(level: :warn)
        end
      end
    end
  end
end
