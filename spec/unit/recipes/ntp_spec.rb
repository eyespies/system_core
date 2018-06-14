require 'spec_helper'

describe 'system_core::ntp' do
  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond to
  # specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      context "On #{platform} #{version} setup the localtime" do
        before do
          # Mock accepting the include_recipe commands
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ntp::default')
          stub_command("[ `readlink /etc/localtime` == \"/usr/share/zoneinfo/EST5EDT\" ]").and_return(false)
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        it 'should include the ntp::default recipe' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ntp::default')
          chef_run
        end

        it 'should configure the zone info in /etc/localtime' do
          expect(chef_run).to run_execute 'configure_ntp'
        end

        # it 'should enable and start the NTP service' do
        #   expect(chef_run).to enable_service 'ntpd'
        #   expect(chef_run).to start_service 'ntpd'
        # end
      end

      context "On #{platform} #{version} localtime is set and does not need updated" do
        before do
          # Mock accepting the include_recipe commands
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ntp::default')
          stub_command("[ `readlink /etc/localtime` == \"/usr/share/zoneinfo/EST5EDT\" ]").and_return(true)
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        it 'should include the ntp::default recipe' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ntp::default')
          chef_run
        end

        # TODO: Add a/b testing to handle both combinations fo
        #  not_if '[ `readlink /etc/localtime` == "/usr/share/zoneinfo/EST5EDT" ]'
        it 'should configure the zone info in /etc/localtime' do
          expect(chef_run).to_not run_execute 'configure_ntp'
        end

        # it 'should enable and start the NTP service' do
        #   expect(chef_run).to enable_service 'ntpd'
        #   expect(chef_run).to start_service 'ntpd'
        # end
      end
    end
  end
end
