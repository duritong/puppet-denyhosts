# the basic setup
class denyhosts::base  {
  package {'denyhosts':
    ensure  => present,
  }

  service {'denyhosts':
    ensure  => running,
    enable  => true,
    require => File['/var/lib/denyhosts/allowed-hosts'],
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
    '/var/lib/denyhosts/allowed-hosts':
      owner   => root,
      group   => 0,
      mode    => '0600';
  }

  if $allowed_hosts == 'autodiscover' {
    $prepare_allowed_hosts = true
    Denyhosts::Allowed_host <<||>>
  } elsif is_array($allowed_hosts) and !empty($allowed_hosts) {
    $prepare_allowed_hosts = true
    denyhosts::alowed_host{
      $denyhosts::allowed_hosts:
    }
  } elsif $allowed_hosts != 'unmanaged' {
    $prepare_allowed_hosts = false
    File['/var/lib/denyhosts/allowed-hosts']{
      content => $allowed_hosts,
      require => Package['denyhosts'],
      notify  => Service['denyhosts'],
    }
  } else {
    $prepare_allowed_hosts = false
  }
  if $prepare_allowed_hosts {
    file{
      '/var/lib/denyhosts':
        ensure  => directory,
        owner   => root,
        group   => 0,
        mode    => '0700';
    }
    File['/var/lib/denyhosts/allowed-hosts']{
      source  => 'puppet:///modules/denyhosts/allowed-hosts',
      replace => false,
      before  => Package['denyhosts'],
      notify  => Service['denyhosts'],
    }
  }
}
