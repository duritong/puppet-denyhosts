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

    file{'/var/lib/denyhosts':
        ensure => directory,
        owner => root, group => 0, mode => 0700; 
    }
    file{'/var/lib/denyhosts/allowed-hosts':
        source => [ "puppet://$server/files/denyhosts/${fqdn}/allowed-hosts", 
                    "puppet://$server/files/denyhosts/allowed-hosts",
                    "puppet://$server/denyhosts/allowed-hosts" ],
        notify => Service[denyhosts],
        mode => 0600, owner => root, group => 0;
    }
}
