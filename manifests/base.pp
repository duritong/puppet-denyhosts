# the basic setup
class denyhosts::base  {
  package {'denyhosts':
    ensure  => present,
    require => [ File['/etc/denyhosts.conf'],
      File['/var/lib/denyhosts/allowed-hosts'] ],
  }

  service {'denyhosts':
    ensure  => running,
    enable  => true,
    require => [ Package['denyhosts'],
      File['/etc/denyhosts.conf'],
      File['/var/lib/denyhosts/allowed-hosts'] ],
  }

  file {
    '/etc/denyhosts.conf':
      source  => ["puppet:///modules/site_denyhosts/${::fqdn}/denyhosts.conf",
                  "puppet:///modules/site_denyhosts/${::operatingsystem}/denyhosts.conf",
                  'puppet:///modules/site_denyhosts/denyhosts.conf',
                  "puppet:///modules/denyhosts/${::operatingsystem}/denyhosts.conf",
                  'puppet:///modules/denyhosts/denyhosts.conf' ],
      notify  => Service['denyhosts'],
      owner   => root,
      group   => 0,
      mode    => '0600';
    '/var/lib/denyhosts':
      ensure  => directory,
      before  => Package['denyhosts'],
      owner   => root,
      group   => 0,
      mode    => '0700';
    '/var/lib/denyhosts/allowed-hosts':
      source  => 'puppet:///modules/denyhosts/allowed-hosts',
      replace => false,
      before  => Package['denyhosts'],
      notify  => Service['denyhosts'],
      owner   => root,
      group   => 0,
      mode    => '0600';
  }

  Denyhosts::Allowed_host <<||>>
}
