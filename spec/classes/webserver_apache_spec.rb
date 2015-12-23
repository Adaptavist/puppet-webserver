require 'spec_helper'

def_mods           = []
def_amods          = []
def_default_vhosts = {}
amods              = ['cache', 'disk_cache']
incorrect_default_mods = {}
cust_mods = ['dav', 'dir']
host = {'webserver::mods' => cust_mods}

describe 'webserver::apache', :type => 'class' do
  
  context "should validate default_mods" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    let(:params) { {
      :default_mods => incorrect_default_mods,
    } }
    it { 
      expect { should contain_class('apache') }.to raise_error(Puppet::Error) 
    }
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
        'default_mods'        => def_mods,
        'default_confd_files' => false,
        'default_vhost'       => false,
        'purge_configs'       => true,
        'server_signature'    => 'Off',
        'server_tokens'       => 'Prod',
        'trace_enable'        => 'Off',
      )
    end    
  end

  context "Should create apache mod passed as param" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    let(:params){{
      :amods => amods,
      }}
    it do
      amods.each do |mod|
        should contain_apache__mod(mod)
      end
    end    
  end
  
  context "Should merge apache mod passed as param amod with ones defined in host hash as webserver::apache::mods" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
      :host => host,
    }}
    let(:params){{
      :amods => amods,
      }}
    it do
      amods.each do |mod|
        should contain_apache__mod(mod)
      end
      cust_mods.each do |cmod|
        should contain_apache__mod(cmod)
      end
    end
  end

end
