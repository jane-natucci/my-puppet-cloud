class cloud::firewall::dns () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'SSH':
    ensure  => present,
    service => 'ssh',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from VPN in Frankfurt':
    ensure  => present,
    source  => "${::cloud::params::ip_vpn}",
    action  => 'accept',
    require => Service['firewalld'],
  }
}
