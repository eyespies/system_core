require 'spec_helper'

describe 'system_core::user_ssh' do
  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond to
  # specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      # NOTE: Currently unable to test the 'without any custom user SSH keys' because defaults are set for both the
      # authorized_keys and the user_config. Have tried unsetting / deleting / setting the values to nil, but it
      # does not work.
      context "On #{platform} #{version}, with custom SSH configuration for a user" do
        before do
          # Don't use allow_any_instance_of because :home is a static / class scoped method and not an instance method.
          allow(Dir).to receive(:home).with('root').and_return('/root')
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.default['environment'] = 'dev'

          # Must use node.override
          runner.node.override['system_core']['aws']['profiles']['default']['access_key'] = 'AKIASOMETHINGFAKE'
          runner.node.override['system_core']['aws']['profiles']['default']['secret_key'] = 'thisismyreallylongawssectaccesskey'

          runner.node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['*']['SendEnv'] = 'LANG LC_*'
          runner.node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['*']['ForwardAgent'] = 'yes'
          runner.node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['*']['HostkeyAlgorithms'] = '+ssh-ed25519,ssh-rsa,ssh-dss,ecdsa-sha2-nistp256'
          runner.node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['*']['UserKnownHostsFile'] = '/dev/null'
          runner.node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['*']['StrictHostKeyChecking'] = 'no'

          runner.node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['github.com bitbucket.org bitbucket.com']['IdentityFile'] = '~/.ssh/id_rsa-chef-solo'
          runner.node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['github.com bitbucket.org bitbucket.com']['UserKnownHostsFile'] = '~/.ssh/known_hosts'
          runner.node.default['system_core']['ssh']['user_config']['root']['config']['hosts']['github.com bitbucket.org bitbucket.com']['StrictHostKeyChecking'] = 'yes'
          runner.converge(described_recipe)
        end

        it 'should create the users home and .ssh directories' do
          expect(chef_run).to create_directory('/root')
          expect(chef_run).to create_directory('/root/.ssh')
        end

        it 'should create the user specific SSH configuration file' do
          expect(chef_run).to create_template('/root/.ssh/config')
        end

        it 'should NOT create the SSH public/private key files' do
          expect(chef_run).to_not create_s3_file('/root/.ssh/id_rsa-chef-solo')
          expect(chef_run).to_not create_s3_file('/root/.ssh/id_rsa-chef-solo.pub')
        end
      end

      context "On #{platform} #{version}, with custom SSH keys for a user" do
        before do
          # Don't use allow_any_instance_of because :home is a static / class scoped method and not an instance method.
          allow(Dir).to receive(:home).with('root').and_return('/root')
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.default['environment'] = 'dev'

          # Must use node.override
          runner.node.override['system_core']['aws']['profiles']['default']['access_key'] = 'AKIASOMETHINGFAKE'
          runner.node.override['system_core']['aws']['profiles']['default']['secret_key'] = 'thisismyreallylongawssectaccesskey'

          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['owner'] = 'root'
          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['ssh_key_bucket'] = 'private.thespies.org'
          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['ssh_key_path'] = 'ssh-keys/chef-solo'
          runner.converge(described_recipe)
        end

        it 'should create the users home directory' do
          expect(chef_run).to create_directory('/root')
        end

        it 'should create the SSH public/private key files' do
          expect(chef_run).to create_s3_file('/root/.ssh/id_rsa-chef-solo')
          expect(chef_run).to create_s3_file('/root/.ssh/id_rsa-chef-solo.pub')
        end
      end

      context "On #{platform} #{version}, with custom SSH keys but missing AWS keys" do
        before do
          # Don't use allow_any_instance_of because :home is a static / class scoped method and not an instance method.
          allow(Dir).to receive(:home).with('root').and_return('/root')
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.default['environment'] = 'dev'

          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['owner'] = 'root'
          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['ssh_key_bucket'] = 'private.thespies.org'
          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['ssh_key_path'] = 'ssh-keys/chef-solo'
          runner.converge(described_recipe)
        end

        it 'should create the users home and .ssh directories' do
          expect(chef_run).to create_directory('/root')
          expect(chef_run).to create_directory('/root/.ssh')
        end

        it 'should NOT create the SSH public/private key files' do
          expect(chef_run).to_not create_s3_file('/root/.ssh/id_rsa-chef-solo')
          expect(chef_run).to_not create_s3_file('/root/.ssh/id_rsa-chef-solo.pub')
        end
      end
    end
  end
end
