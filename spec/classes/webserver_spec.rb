require 'spec_helper'

def_default_mods = []
describe 'webserver', :type => 'class' do
    
  context "Should initiate apache and vhost as default webserver" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
      }}
    it do
      should contain_anchor('webserver::apache::start').that_comes_before('Class[webserver::apache]')
      should contain_class('webserver::apache').that_notifies('Class[webserver::apache::vhosts]')
      should contain_class('webserver::apache::vhosts').that_notifies('Anchor[webserver::apache::end]')
      should_not contain_selboolean('httpd_can_network_relay')
      should_not contain_selboolean('httpd_can_network_connect')
    end    
  end
  describe "Should set selboolean on selinux as default for apache" do
    let(:facts){{ 
      :selinux => true,
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    it do
    should contain_selboolean('httpd_can_network_relay').with(
      'persistent' => true,
      'value'      => 'on',
   )
    should contain_selboolean('httpd_can_network_connect').with(
      'persistent' => true,
      'value'      => 'on',
   )
    end
  end

  context "Should fail for unsupported server type" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    let(:params){{:server_type => 'nginx'}}
    it { expect { should contain_class('apache') }.to raise_error(Puppet::Error) }
  end

context "Should initiate apache class" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    let(:params){{:server_type => 'apache'}}
    it do
      should contain_class('apache').with(
        'default_mods'        => def_default_mods,
        'default_confd_files' => false,
        'default_vhost'       => false,
        'purge_configs'       => true,
        'server_signature'    => 'Off',
        'server_tokens'       => 'Prod',
        'trace_enable'        => 'Off',
      )
    end    
  end

  context "Should initiate apache class" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    it do
      should contain_class('apache').with(
        'default_mods'        => def_default_mods,
        'default_confd_files' => false,
        'default_vhost'       => false,
        'purge_configs'       => true,
        'server_signature'    => 'Off',
        'server_tokens'       => 'Prod',
        'trace_enable'        => 'Off',
      )
    end
  end
end
