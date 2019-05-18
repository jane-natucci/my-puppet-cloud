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

  firewalld_rich_rule {'accept http from VPN in Frankfurt':
    ensure  => present,
    source  => "${::cloud::params::ip_vpn}",
    action  => 'accept',
    service => 'http',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept https from VPN in Frankfurt':
    ensure  => present,
    source  => "${::cloud::params::ip_vpn}",
    action  => 'accept',
    service => 'https',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept https from VPN in London':
    ensure  => present,
    source  => "51.77.126.243",
    action  => 'accept',
    service => 'https',
    require => Service['firewalld'],
  }
}
