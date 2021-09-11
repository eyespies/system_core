require 'spec_helper'

describe 'system_core::repos' do
  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond
  # to specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      context "On #{platform} #{version} setup YUM repositories and remove MySQL if is not updated" do
        before do
          # Mock accepting the include_recipe commands
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('yum')
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt::default')
          stub_command("yum list installed|grep mysql55w-libs").and_return(false)
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.default['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        let(:packages) do
          chef_run.node['system_core']['system']['packages']
        end

        it 'should call the necessary YUM recipes' do
          if platform == 'ubuntu'
            expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt::default')
            expect_any_instance_of(Chef::Recipe).to_not receive(:include_recipe).with('yum')
          else
            expect_any_instance_of(Chef::Recipe).to_not receive(:include_recipe).with('apt::default')
            expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('yum')
          end
          chef_run
        end

        it 'should delete any cobbler created repo files' do
          expect(chef_run).to delete_file('/etc/yum.repos.d/cobbler-config.repo')
        end

        # The yum repository is only setup on Oracle or RHEL 7 and each one is different
        if version =~ /^7/
          if platform == "oracle"
            it 'should delete the existing Oracle repo configuration' do
              expect(chef_run).to delete_file('/etc/yum.repos.d/public-yum-ol7.repo')
            end

            %w[ol7_optional_latest ol7_base_latest ol7_uek4_latest ol7_uek5_latest].each do |repo|
              it "should enable the '#{repo}' repo for Oracle Linux 7" do
                expect(chef_run).to create_yum_repository(repo)
              end
            end
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
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('yum')
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt::default')
          stub_command("yum list installed|grep mysql55w-libs").and_return(true)
        end

        cached(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.default['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        let(:packages) do
          chef_run.node['system_core']['system']['packages']
        end

        it 'should call the necessary YUM recipes' do
          if platform == 'ubuntu'
            expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('apt::default')
            expect_any_instance_of(Chef::Recipe).to_not receive(:include_recipe).with('yum')
          else
            expect_any_instance_of(Chef::Recipe).to_not receive(:include_recipe).with('apt::default')
            expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('yum')
          end

          chef_run
        end

        it 'should delete any cobbler created repo files' do
          expect(chef_run).to delete_file('/etc/yum.repos.d/cobbler-config.repo')
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
