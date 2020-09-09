class cloud::firewall::www () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'ssh':
    ensure  => present,
    service => 'ssh',
    require  => Service['firewalld'],
  }

  firewalld_service {'http':
    ensure  => present,
    service => 'http',
    require  => Service['firewalld'],
  }
}
