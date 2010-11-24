define denyhosts::allowed_host(
  $ipaddress = $ip,
  $ensure = 'present'
){
  include ::denyhosts
  line{"denyhosts_allowed_host_${name}":
    file => '/var/lib/denyhosts/allowed-hosts',
    line => $ip,
    ensure => $ensure,
    require => File['/var/lib/denyhosts/allowed-hosts'],
    notify => Service['denyhosts'],
  }
}
