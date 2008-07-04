#
# denyhosts module
#
# Copyright 2008, Puzzle ITC GmbH
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#
# This module is used to configure the
# denyhosts script.
#

# modules_dir { "denyhosts": }

class denyhosts {
    case $operatingsystem {
        gentoo: { include denyhosts::gentoo }
        default: { include denyhosts::base }
    }
}

class denyhosts::base  {
    package{denyhosts:
        ensure => present,
    }

    service{denyhosts:
        enable => true,
        ensure => running,
        require => [ Package[denyhosts], 
            File["/etc/denyhosts.conf"], 
            File["/var/lib/denyhosts/allowed-hosts"] ],
    }

    file{'/etc/denyhosts.conf':
        source => [ "puppet://$server/files/denyhosts/${fqdn}/denyhosts.conf", 
                    "puppet://$server/files/denyhosts/denyhosts.conf",
                    "puppet://$server/denyhosts/denyhosts.conf" ],
        notify => Service[denyhosts],
        mode => 0600, owner => root, group => 0;
    }

    file{'/var/lib/denyhosts/':
        ensure => directory,
        owner => root, group => 0, mode => 0700; 
    }
    file{'/var/lib/denyhosts/allowed-hosts':
        source => [ "puppet://$server/files/denyhosts/${fqdn}/allowed-hosts", 
                    "puppet://$server/files/denyhosts/allowed-hosts",
                    "puppet://$server/denyhosts/allowed-hosts" ],
        notify => Service[denyhosts],
        require => File['/var/lib/denyhosts/'],
        mode => 0600, owner => root, group => 0;
    }
}

class denyhosts::gentoo inherits denyhosts::base {
    Package[denyhosts]{
        category => 'app-admin',
    }
}
