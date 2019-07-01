class cloud::firewall::gitlab () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'SSH':
    ensure  => present,
    service => 'ssh',
    require => Service['firewalld'],
  }
}
