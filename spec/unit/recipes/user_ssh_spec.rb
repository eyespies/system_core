require 'spec_helper'

describe 'system_core::user_ssh' do
  # Used by Fauxhai to retrieve configuration details that are feed into ChefSpec; these correspond to
  # specific URLs that must exist
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      # NOTE: Currently unable to test the 'without any custom user SSH keys' because defaults are set for both the
      # authorized_keys and the user_config. Have tried unsetting / deleting / setting the values to nil, but it
      # does not work.
      context "On #{platform} #{version}, with custom SSH configuration for a user" do
        before do
          # Fauxhai.mock(path: opts['fixture_path'])

          # Don't use allow_any_instance_of because :home is a static / class scoped method and not an instance method.
          allow(Dir).to receive(:home).with('root').and_return('/root')
          allow_any_instance_of(Chef::Recipe).to receive(:ssh_authorize_key)
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, path: opts['fixture_path'])
          # runner = ChefSpec::SoloRunner.new
          runner.node.default['environment'] = 'dev'

          runner.node.default['system_core']['ssh']['authorized_keys']['root@mydomain.com']['public_key'] = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJlvaL0I0HWNE/RblFscFWhjXDwX6UaMBLtG5YdbHHSc1QQO+W+kV15q3T7WnED6In+aK423OzMTk/0/UZrchlxa2KCRNSnRrqViTZZ1XUXwEXqCnBQ9O1El93AAaE73suB9kYfeO105D5AgTTmf41HDc4YAxZtoAOt2KdI2GF7+7IfheI54aWSldmQesfqNloY+ivYIOhyEIwXuO9RS2BEbrFoxuVfOcz62AGcFz07EsALWGNzr4ngT6pe8vCbV5s/f0cDk5z9XZ4Wk2uQI7NQuLkSOmokU3QqZhOYJUjjTdq8VrjARWdF7K5N0/LQ/Wyx6Tgy+XRavnmj/SMhaKd' # rubocop:disable Layout/LineLength
          runner.node.default['system_core']['ssh']['authorized_keys']['root@mydomain.com']['user'] = 'root'

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

        it 'should configure the SSH authorized keys' do
          expect_any_instance_of(Chef::Recipe).to receive(:ssh_authorize_key)
          chef_run
        end

        it 'should create the user specific SSH configuration file' do
          expect(chef_run).to create_template('/root/.ssh/config')
        end
      end

      context "On #{platform} #{version}, with custom SSH keys for a user" do
        before do
          # Don't use allow_any_instance_of because :home is a static / class scoped method and not an instance method.
          allow(Dir).to receive(:home).with('root').and_return('/root')
          allow_any_instance_of(Chef::Recipe).to receive(:ssh_authorize_key)
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, path: opts['fixture_path'])
          runner.node.default['environment'] = 'dev'

          runner.node.default['system_core']['ssh']['authorized_keys']['root@mydomain.com']['public_key'] = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJlvaL0I0HWNE/RblFscFWhjXDwX6UaMBLtG5YdbHHSc1QQO+W+kV15q3T7WnED6In+aK423OzMTk/0/UZrchlxa2KCRNSnRrqViTZZ1XUXwEXqCnBQ9O1El93AAaE73suB9kYfeO105D5AgTTmf41HDc4YAxZtoAOt2KdI2GF7+7IfheI54aWSldmQesfqNloY+ivYIOhyEIwXuO9RS2BEbrFoxuVfOcz62AGcFz07EsALWGNzr4ngT6pe8vCbV5s/f0cDk5z9XZ4Wk2uQI7NQuLkSOmokU3QqZhOYJUjjTdq8VrjARWdF7K5N0/LQ/Wyx6Tgy+XRavnmj/SMhaKd' # rubocop:disable Layout/LineLength
          runner.node.default['system_core']['ssh']['authorized_keys']['root@mydomain.com']['user'] = 'root'

          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['owner'] = 'root'
          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['ssh_key_bucket'] = 'private.thespies.org'
          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['ssh_key_path'] = 'ssh-keys/chef-solo'
          runner.converge(described_recipe)
        end

        it 'should create the users home directory' do
          expect(chef_run).to create_directory('/root')
        end

        it 'should configure the SSH authorized keys' do
          expect_any_instance_of(Chef::Recipe).to receive(:ssh_authorize_key)
          chef_run
        end
      end

      context "On #{platform} #{version}, with custom SSH keys but missing AWS keys" do
        before do
          # Don't use allow_any_instance_of because :home is a static / class scoped method and not an instance method.
          allow(Dir).to receive(:home).with('root').and_return('/root')
          allow_any_instance_of(Chef::Recipe).to receive(:ssh_authorize_key)
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version, path: opts['fixture_path'])
          runner.node.default['environment'] = 'dev'

          runner.node.default['system_core']['ssh']['authorized_keys']['root@mydomain.com']['public_key'] = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJlvaL0I0HWNE/RblFscFWhjXDwX6UaMBLtG5YdbHHSc1QQO+W+kV15q3T7WnED6In+aK423OzMTk/0/UZrchlxa2KCRNSnRrqViTZZ1XUXwEXqCnBQ9O1El93AAaE73suB9kYfeO105D5AgTTmf41HDc4YAxZtoAOt2KdI2GF7+7IfheI54aWSldmQesfqNloY+ivYIOhyEIwXuO9RS2BEbrFoxuVfOcz62AGcFz07EsALWGNzr4ngT6pe8vCbV5s/f0cDk5z9XZ4Wk2uQI7NQuLkSOmokU3QqZhOYJUjjTdq8VrjARWdF7K5N0/LQ/Wyx6Tgy+XRavnmj/SMhaKd' # rubocop:disable Layout/LineLength
          runner.node.default['system_core']['ssh']['authorized_keys']['root@mydomain.com']['user'] = 'root'

          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['owner'] = 'root'
          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['ssh_key_bucket'] = 'private.thespies.org'
          runner.node.default['system_core']['ssh']['user_config']['root']['keys']['id_rsa-chef-solo']['ssh_key_path'] = 'ssh-keys/chef-solo'
          runner.converge(described_recipe)
        end

        it 'should create the users home and .ssh directories' do
          expect(chef_run).to create_directory('/root')
          expect(chef_run).to create_directory('/root/.ssh')
        end

        it 'should configure the SSH authorized keys' do
          expect_any_instance_of(Chef::Recipe).to receive(:ssh_authorize_key)
          chef_run
        end
      end
    end
  end
end
