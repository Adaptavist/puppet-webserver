class webserver::apache(
    $default_mods           = $webserver::params::default_mods,
    $amods                  = $webserver::params::amods,
    $crowd_auth             = $webserver::params::crowd_auth,
    $crowd_svn_auth         = $webserver::params::crowd_svn_auth,
    $dav_svn_authz_path     = undef,
    $dav_svn_authz_location = undef,
    $authz_svn_crowd_mods   = $webserver::params::authz_svn_crowd_mods,
    $authz_crowd_mods       = $webserver::params::authz_crowd_mods,
    $authz_crowd_package    = $webserver::params::authz_crowd_package,
    $webserver_users        = {},
    $purge_configs          = $webserver::params::purge_configs,
  ) inherits webserver::params {
  validate_array($default_mods)

  if $::host != undef {
    $mods = sort(unique($host['webserver::mods'] ? {
      undef   => $amods,
      default => concat($amods ? { undef => [], default => $amods }, $host['webserver::mods']),
    }))
  } else {
    $mods = $amods
  }

  validate_array($mods)

  if ( str2bool($crowd_auth) or str2bool($crowd_svn_auth) ){
      
      # Make sure repo where this package is located is registered
      package {$authz_crowd_package:
      }
      
      if( str2bool($crowd_svn_auth) ){
        $authz_mods = $authz_svn_crowd_mods
        if ($dav_svn_authz_path == undef or $dav_svn_authz_location == undef){
          fail('Please provide dav_svn_authz_path and dav_svn_authz_location parameters')
        }

        file { $dav_svn_authz_path:
          ensure => file,
          source => $dav_svn_authz_location,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
        }
      }else{
        $authz_mods = $authz_crowd_mods
      }

      apache::mod { $authz_mods:
        require => Package[$authz_crowd_package],
      }
  }

  class { '::apache':
    default_mods        => $default_mods,
    default_confd_files => false,
    default_vhost       => false,
    purge_configs       => str2bool($purge_configs),
    server_signature    => 'Off',
    server_tokens       => 'Prod',
    trace_enable        => 'Off',
  }
  Apache::Mod<||> -> Webserver::Apache::Htpasswd<||>
  create_resources('webserver::apache::htpasswd', $webserver_users)
  
  apache::mod { $mods : }
}
