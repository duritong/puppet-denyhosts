# manages an allowed host entry
# requires that the denyhosts class is
# included in your catalog.
define denyhosts::allowed_host(
  $ip     = $name,
  $ensure = 'present'
){
  file_line{"denyhosts_allowed_host_${name}":
    ensure  => $ensure,
    path    => '/var/lib/denyhosts/allowed-hosts',
    line    => $ip,
    require => File['/var/lib/denyhosts/allowed-hosts'],
    notify  => Service['denyhosts'],
  }
}
