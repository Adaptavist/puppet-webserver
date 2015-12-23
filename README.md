# WebServer Module

## Overview

The **WebServer** module install and configures webserver and settings. By default it will install Apache.

For a complete guide to the configuration parameters see:
https://forge.puppetlabs.com/puppetlabs/apache

## Configuration

This module is configured via Hiera, with:

A hash of default vhosts:
  webserver::apache::default_vhosts:

An array of default modules:
  webserver::apache::default_mods:

A hash of host specific vhosts:
  hosts:
    "hostname":
      webserver::apache::vhosts:

A hash of host specific modules:
  hosts:
    "hostname":
      webserver::apache::mods:

Modules can sometimes need to be loaded in a specific order, on systems where softlinks are used
(mods-enabled for example) prefix character can be used to achieve this, in Hierra this can be done
by adding ~<PREFIX> after the module name, for example dav_svn~1 will create 1dav_svn.load

Example Hierra config:
  hosts:
    "hostname:" 
      webserver::mods:
        - deflate
        - dav~1
        - dav_svn~1
        - auth_basic

Module can register and provide mods for crowd integration. 

* webserver::crowd_auth: "true" (default false) to install mods required for crowd authentication
* webserver::crowd_svn_auth: "true" (default false) to install mods required for crowd svn authentication
* webserver::apache::dav_svn_authz_path: "/opt/dav_svn.authz" location of svn crowd access config file on server, must be provided in case crowd_svn_auth is set to true
* webserver::apache::dav_svn_authz_location: "puppet:///files/dav_svn.authz" path to config file in puppet config, must be provided in case crowd_svn_auth is set to true 
* webserver::apache::authz_svn_crowd_mods: overwritable array of custom mods for crowd svn, defaults to ['dav_svn', 'dav','auth_basic','authz_svn_crowd~z', 'authnz_crowd~y', 'authz_svn~x']
* webserver::apache::authz_crowd_mods: overwritable array of custom mods for crowd svn, defaults to ['dav','auth_basic', 'authnz_crowd~y']

## Dependencies

This module requires stdlib and puppetlabs-apache.

