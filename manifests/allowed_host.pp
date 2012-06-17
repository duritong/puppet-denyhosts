define denyhosts::allowed_host(
  $ip,
  $ensure = 'present'
){
  include ::denyhosts
  file_line{"denyhosts_allowed_host_${name}":
    path => '/var/lib/denyhosts/allowed-hosts',
    line => $ip,
    ensure => $ensure,
    require => File['/var/lib/denyhosts/allowed-hosts'],
    notify => Service['denyhosts'],
  }
}
