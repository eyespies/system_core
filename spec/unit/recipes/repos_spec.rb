require 'spec_helper'

describe 'system_core::repos' do
  ol7_repos = %w(ol7_base_latest
                 ol7_addons_latest
                 ol7_uek4_latest
                 ol7_uek5_latest
                 ol7_uek6_latest
                 ol7_optional_latest
                 ol7_epel_latest)
  # ol7_kvm_utilities_latest
  # ol7_ovirt43_latest
  # ol7_ovirt43_extras_latest
  # ol7_gluster6_latest
  # ol7_gluster8_latest
  # ol7_php_latest

  ol8_repos = %w(ol8_addons_latest
                 ol8_appstream_latest
                 ol8_base_latest
                 ol8_epel_latest
                 ol8_uek6_latest)
  #  ol8_codeready_latest
  #  ol8_kvm_appstream_latest
  #  ol8_automation_manager_latest
  #  ol8_gluster_appstream_latest

  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond
  # to specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      context "On #{platform} #{version} setup YUM repositories and remove MySQL if is not updated" do
        before do
          # Mock accepting the include_recipe commands
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('yum')
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt::default')
          stub_command("yum list installed|grep mysql55w-libs").and_return(false)
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, path: opts['fixture_path'])
          runner.node.default['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        let(:packages) do
          chef_run.node['system_core']['system']['packages']
        end

        it 'should properly handle the Ubuntu apt recipe' do
          if platform == 'ubuntu'
            expect(chef_run).to update_apt_update('update_apt')
          else
            expect(chef_run).to_not update_apt_update('update_apt')
          end
        end

        it 'should delete any cobbler created repo files' do
          expect(chef_run).to delete_file('/etc/yum.repos.d/cobbler-config.repo')
        end

        major_version = version.split('.')[0]
        # The yum repository is only setup on Oracle or RHEL 7 and each one is different
        if platform == 'oracle'
          if major_version == '7'
            it 'should delete the existing Oracle repo configuration' do
              expect(chef_run).to delete_file('/etc/yum.repos.d/public-yum-ol7.repo')
              expect(chef_run).to delete_file('/etc/yum.repos.d/oracle-linux-ol7.repo')
            end

            ol7_repos.each do |repo|
              it "should enable the #{repo} repo for Oracle Linux 7" do
                expect(chef_run).to create_yum_repository(repo)
              end
            end
          elsif major_version == '8'
            it 'should delete the existing Oracle repo configuration' do
              expect(chef_run).to delete_file('/etc/yum.repos.d/oracle-linux-ol8.repo')
            end

            ol8_repos.each do |repo|
              it "should enable the #{repo} repo for Oracle Linux 8" do
                expect(chef_run).to create_yum_repository(repo)
              end
            end
          else
            puts "No repos configured for #{platform} Linux version #{major_version}"
          end
        end

        it 'should install the necessary additional packages' do
          packages.each do |pkg|
            expect(chef_run).to install_package(pkg)
          end
        end
      end

      context "On #{platform} #{version} setup YUM repositories and not update MySQL if it is already updated" do
        before do
          # Mock accepting the include_recipe commands
          stub_command("yum list installed|grep mysql55w-libs").and_return(true)
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, path: opts['fixture_path'])
          runner.node.default['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        let(:packages) do
          chef_run.node['system_core']['system']['packages']
        end

        it 'should properly handle the Ubuntu apt recipe' do
          if platform == 'ubuntu'
            expect(chef_run).to update_apt_update('update_apt')
          else
            expect(chef_run).to_not update_apt_update('update_apt')
          end
        end

        it 'should delete any cobbler created repo files' do
          expect(chef_run).to delete_file('/etc/yum.repos.d/cobbler-config.repo')
        end

        major_version = version.split('.')[0]
        # The yum repository is only setup on Oracle or RHEL 7 and each one is different
        if platform == 'oracle'
          if major_version == '7'
            it 'should delete the existing Oracle repo configuration' do
              expect(chef_run).to delete_file('/etc/yum.repos.d/public-yum-ol7.repo')
            end

            ol7_repos.each do |repo|
              it "should enable the #{repo} repo for Oracle Linux 7" do
                expect(chef_run).to create_yum_repository(repo)
              end
            end
          elsif major_version == '8'
            it 'should delete the existing Oracle repo configuration' do
              expect(chef_run).to delete_file('/etc/yum.repos.d/oracle-linux-ol8.repo')
            end

            ol8_repos.each do |repo|
              it "should enable the #{repo} repo for Oracle Linux 8" do
                expect(chef_run).to create_yum_repository(repo)
              end
            end
          else
            puts "No repos configured for #{platform} Linux version #{major_version}"
          end
        end

        it 'should install the necessary additional packages' do
          packages.each do |pkg|
            expect(chef_run).to install_package(pkg)
          end
        end
      end
    end
  end
end
