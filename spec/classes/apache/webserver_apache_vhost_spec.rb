require 'spec_helper'

cust_default_vhosts = {
  '_default_' => {
      'servername' => 'localhost.localdomain',
      'port' => '80',
      'docroot' => '/nonexistant',
    },
  '_default_ssl_' => {
      'servername' => 'localhost.localdomain',
      'port' => '443',
      'docroot' => '/nonexistant',
    }
}

cust_vhosts = {
  '_host_specific_vhost' => {
      'servername' => 'localhost.localdomain',
      'port' => '123',
      'docroot' => '/nonexistant',
    },
}
host = {'webserver::vhosts' => cust_vhosts}
error_host = {'webserver::vhosts' => []}
incorrect_default_vhosts = []

describe 'webserver::apache::vhosts', :type => 'class' do
  
  context "should validate default_vhosts" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    let(:params) { {
      :default_vhosts => incorrect_default_vhosts,
    } }
    it { 
      expect { should contain_class('apache') }.to raise_error(Puppet::Error) 
    }
  end

  context "Should create vhosts passed as params" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    let(:params){{ :default_vhosts => cust_default_vhosts }}
    it do
      cust_default_vhosts.keys.each do |vhost|
        should contain_apache__vhost(vhost)
      end
    end    
  end

  context "Should include webserver::apache" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    it do
      should contain_webserver__apache
    end    
  end
  
  context "Should create vhosts passed in host" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
      :host => host,
    }}
    let(:params){{ :default_vhosts => cust_default_vhosts }}
    it do
      cust_default_vhosts.keys.each do |vhost|
        should contain_apache__vhost(vhost)
      end
      cust_vhosts.keys.each do |vhost|
        should contain_apache__vhost(vhost)
      end
    end    
  end

  context "should validate host -> webserver::apache::vhosts as hash" do
    let(:facts) {{
      :osfamily => 'Debian',
      :operatingsystemrelease => '5.0.9',
      # config for concat
      :concat_basedir => '/var/lib/puppet/concat',
      :host => error_host,
    }}
    let(:params) { {
      :default_vhosts => incorrect_default_vhosts,
    } }
    it { 
      expect { should contain_class('apache') }.to raise_error(Puppet::Error) 
    }
  end
end
