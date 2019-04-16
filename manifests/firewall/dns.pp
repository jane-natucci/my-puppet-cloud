class cloud::firewall::dns () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'SSH':
    ensure  => present,
    service => 'ssh',
  }

  firewalld_rich_rule {'accept everything from node1':
    ensure  => present,
    source  => "${::cloud::params::ip_node1}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from node2':
    ensure  => present,
    source  => "${::cloud::params::ip_node2}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from node3':
    ensure  => present,
    source  => "${::cloud::params::ip_node3}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from ipa':
    ensure  => present,
    source  => "${::cloud::params::ip_ipa}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from gitlab':
    ensure  => present,
    source  => "${::cloud::params::ip_gitlab}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from jenkins':
    ensure  => present,
    source  => "${::cloud::params::ip_jenkins}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from natucci.de':
    ensure  => present,
    source  => "${::cloud::params::ip_natucci}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from VPN in Frankfurt':
    ensure  => present,
    source  => "${::cloud::params::ip_vpn}",
    action  => 'accept',
  }
}
