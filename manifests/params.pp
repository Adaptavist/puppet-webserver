class webserver::params{
    $server_type = 'apache'
    $default_mods   = []
    $amods          = []
    $default_vhosts = {}
    $crowd_auth     = false
    $crowd_svn_auth = false
    $authz_crowd_mods = ['dav','auth_basic', 'authnz_crowd~y']
    $authz_svn_crowd_mods = ['dav_svn', 'dav','auth_basic','authz_svn_crowd~z', 'authnz_crowd~y', 'authz_svn~x']
    $authz_crowd_package = $::osfamily ? {
        'Debian' => 'mod-authnz-crowd',
        'RedHat' => 'mod_authnz_crowd',
      }
}
