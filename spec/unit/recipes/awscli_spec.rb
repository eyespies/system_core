require 'spec_helper'

describe 'system_core::awscli' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version, opts|
      [true, false].each do |has_aws|
        [true, false].each do |has_profile|
          context "On #{platform} #{version} #{has_profile ? 'with' : 'without'} an AWS configuration profile and #{has_aws ? 'with' : 'without'} the CLI installed" do
            before do
              Fauxhai.mock(platform: platform, version: version, path: opts['fixture_path']) if opts.key?('fixture_path')
              stub_command('which aws').and_return(has_aws)
            end

            cached(:chef_run) do
              runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
              runner.node.override['environment'] = 'dev'
              if has_profile
                runner.node.override['system_core']['aws']['profiles']['default']['output_format'] = 'json'
                runner.node.override['system_core']['aws']['profiles']['default']['default_region'] = 'us-east-1'
                runner.node.override['system_core']['aws']['profiles']['default']['access_key'] = 'AKIASOMETHINGFAKE'
                runner.node.override['system_core']['aws']['profiles']['default']['secret_key'] = 'thisismyreallylongawssectaccesskey'
              end
              runner.converge(described_recipe)
            end

            it 'should install required packages' do
              chef_run.node['system_core']['awscli']['packages'].each do |pkg|
                expect(chef_run).to install_package(pkg)
              end
            end

            it 'should create the "aws" user' do
              expect(chef_run).to create_user('aws')
            end

            it 'should install the AWS CLI installation script' do
              expect(chef_run).to create_cookbook_file('/tmp/install-aws-cli.sh')
            end

            if has_aws
              it 'should not install the AWS cli' do
                expect(chef_run).to_not run_execute 'install-aws-cli'
              end
            else
              it 'should install the AWS cli' do
                expect(chef_run).to run_execute 'install-aws-cli'
              end
            end

            it 'should create the AWS configuration for the root user when the configs are available' do
              expect(chef_run).to create_directory('/root/.aws')
            end

            if has_profile
              it 'should create the AWS configuration files for the root user' do
                expect(chef_run).to create_template('/root/.aws/config')
                expect(chef_run).to create_template('/root/.aws/credentials')
              end
            else
              it 'should NOT create the AWS configuration files for the root user when no profiles are defined' do
                expect(chef_run).to_not create_template('/root/.aws/config')
                expect(chef_run).to_not create_template('/root/.aws/credentials')
              end
            end
          end
        end
      end
    end
  end
end
