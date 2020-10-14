## Firewall rules for openshift master & node server.

class cloud::firewall::openshift () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'ssh':
    ensure  => present,
    service => 'ssh',
    require => Service['firewalld'],
  }

  firewalld_service {'dhcpv6-client':
    ensure  => present,
    service => 'dhcpv6-client',
    require => Service['firewalld'],
  }

  firewalld_service {'http':
    ensure  => present,
    service => 'http',
    require => Service['firewalld'],
  }

  firewalld_service {'https':
    ensure  => present,
    service => 'https',
    require => Service['firewalld'],
  }

  firewalld_port {'Open port 8443 in the public zone':
    ensure   => present,
    zone     => 'public',
    port     => 8443,
    protocol => 'tcp',
  }

  firewalld_port {'Open port 8444 in the public zone':
    ensure   => present,
    zone     => 'public',
    port     => 8444,
    protocol => 'tcp',
  }

  firewalld_port {'Open port 8053 in the public zone (tcp)':
    ensure   => present,
    zone     => 'public',
    port     => 8053,
    protocol => 'tcp',
  }

  firewalld_port {'Open port 8053 in the public zone (udp)':
    ensure   => present,
    zone     => 'public',
    port     => 8053,
    protocol => 'udp',
  }

  exec {'firewall-cmd --reload':
    path => '/usr/bin',
  }
}
