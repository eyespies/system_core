require 'spec_helper'

describe 'system_core::ssh' do
  platforms.each do |platform, details|
    versions = details['versions']
    versions.each do |version|
      context "On #{platform} #{version}" do
        before do
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openssh')
          allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('sudo')
        end

        let(:chef_run) do
          runner = ChefSpec::SoloRunner.new(platform: platform, version: version)
          runner.node.override['environment'] = 'dev'
          runner.converge(described_recipe)
        end

        it 'should include the necessary dependent recipes' do
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('openssh')
          expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('sudo')

          chef_run
        end

        it 'should create the SSH banner' do
          expect(chef_run).to create_template('/etc/ssh/banner')
          expect(chef_run).to_not create_group('sshusers')
          expect(chef_run).to_not create_group('sudoers')
        end
      end
    end
  end
end
