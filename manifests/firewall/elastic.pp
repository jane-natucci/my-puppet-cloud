class cloud::firewall::elastic () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'ssh':
    ensure  => present,
    service => 'ssh',
    require  => Service['firewalld'],
  }

  firewalld_port { 'Open port 9200 in the public zone':
    ensure   => present,
    zone     => 'public',
    port     => 9200,
    protocol => 'tcp',
    require  => Service['firewalld'],
  }
}
