class webserver(
  $server_type    = $webserver::params::server_type,
  $default_mods   = $webserver::params::default_mods,
  $amods          = $webserver::params::amods,
  $default_vhosts = $webserver::params::default_vhosts,
  $crowd_auth     = $webserver::params::crowd_auth,
  $crowd_svn_auth = $webserver::params::crowd_svn_auth,
  ) inherits webserver::params {

  case $server_type{
    apache: {
      anchor { 'webserver::apache::start': }
      -> Class['webserver::apache']
      ~> Class['webserver::apache::vhosts']
      ~> anchor { 'webserver::apache::end': }

      class { 'webserver::apache':
        default_mods   => $default_mods,
        amods          => $amods,
        crowd_auth     => $crowd_auth,
        crowd_svn_auth => $crowd_svn_auth,
      }

      class { 'webserver::apache::vhosts' :
        default_vhosts => $default_vhosts,
      }

      if str2bool($::selinux) {
        selboolean { 'httpd_can_network_relay':
          persistent => true,
          value      => 'on',
        }
        selboolean { 'httpd_can_network_connect':
          persistent => true,
          value      => 'on',
        }
      }
    }
    nginx: { fail('Very soon we will have nginx provisioning here') }
    default: { fail('At the moment we do not support other webservers, try again later :)') }
  }
}
