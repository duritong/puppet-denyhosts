class denyhosts::base  {
    package { denyhosts:
        ensure => present,
        require => [ File["/etc/denyhosts.conf"],
            File["/var/lib/denyhosts/allowed-hosts"] ],
    }

    service { denyhosts:
        enable => true,
        ensure => running,
        require => [ Package[denyhosts], 
            File["/etc/denyhosts.conf"], 
            File["/var/lib/denyhosts/allowed-hosts"] ],
    }

    file { '/etc/denyhosts.conf':
            source => [ "puppet://$server/modules/site-denyhosts/${fqdn}/denyhosts.conf",
                        "puppet://$server/modules/site-denyhosts/denyhosts.conf",
                        "puppet://$server/modules/denyhosts/denyhosts.conf" ],
            notify => Service[denyhosts],
            mode => 0600, owner => root, group => 0;
        '/var/lib/denyhosts':
            ensure => directory,
            owner => root, group => 0, mode => 0700; 
        '/var/lib/denyhosts/allowed-hosts':
            source => [ "puppet://$server/modules/site-denyhosts/${fqdn}/allowed-hosts", 
                        "puppet://$server/modules/site-denyhosts/allowed-hosts",
                        "puppet://$server/modules/denyhosts/allowed-hosts" ],
            notify => Service[denyhosts],
            mode => 0600, owner => root, group => 0;
    }
}
