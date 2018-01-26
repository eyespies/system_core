require 'spec_helper'

describe 'system_core::auditd' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      context "On #{platform} #{version}" do
        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        it 'should configure auditd' do
          resource = chef_run.service('auditd')
          expect(resource).to do_nothing()
          expect(chef_run).to create_cookbook_file('/etc/audit/auditd.conf')

          resource = chef_run.cookbook_file('/etc/audit/auditd.conf')
          expect(resource).to notify('service[auditd]').to(:restart).delayed
        end
      end
    end
  end
end
