class webserver::apache::vhosts(
    $default_vhosts = $webserver::params::default_vhosts,
    ) inherits webserver::params {

    include webserver::apache
    validate_hash($default_vhosts)
    create_resources(apache::vhost, $default_vhosts)

    if $::host != undef {
        validate_hash($host['webserver::vhosts'])
        create_resources(apache::vhost, $host['webserver::vhosts'])
    }
}
