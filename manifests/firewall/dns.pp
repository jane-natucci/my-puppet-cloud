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

  firewalld_rich_rule {'accept everything from node1':
    ensure  => present,
    source  => "${::cloud::params::ip_node1}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from node2':
    ensure  => present,
    source  => "${::cloud::params::ip_node2}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from node3':
    ensure  => present,
    source  => "${::cloud::params::ip_node3}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from ipa':
    ensure  => present,
    source  => "${::cloud::params::ip_ipa}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from gitlab':
    ensure  => present,
    source  => "${::cloud::params::ip_gitlab}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from jenkins':
    ensure  => present,
    source  => "${::cloud::params::ip_jenkins}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from natucci.de':
    ensure  => present,
    source  => "${::cloud::params::ip_natucci_de}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from ipa.natucci.de':
    ensure  => present,
    source  => "${::cloud::params::ip_ipa}",
    action  => 'accept',
    require => Service['firewalld'],
  }

  firewalld_rich_rule {'accept everything from VPN in Frankfurt':
    ensure  => present,
    source  => "${::cloud::params::ip_vpn}",
    action  => 'accept',
    require => Service['firewalld'],
  }
}
