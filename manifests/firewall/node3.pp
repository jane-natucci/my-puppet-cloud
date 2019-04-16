class cloud::firewall::node3 () inherits ::cloud::params {
  service {'firewalld':
    ensure => running,
    enable => true,
  }

  firewalld_service {'SSH':
    ensure  => present,
    service => 'ssh',
  }

  firewalld_rich_rule {'NodeManager 45454':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '45454',
      protocol => 'tcp',
    },
    action   => 'accept',
  }

  firewalld_rich_rule {'NodeManager 8042':
    ensure   => present,
    source   => '$::cloud::params::ip_vpn',
    port     => {
      port => '8042',
      protocol => 'tcp',
    },
    action   => 'accept',
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

  firewalld_rich_rule {'accept everything from dns':
    ensure  => present,
    source  => "${::cloud::params::ip_dns}",
    action  => 'accept',
  }

  firewalld_rich_rule {'accept everything from ipa':
    ensure  => present,
    source  => "${::cloud::params::ip_ipa}",
    action  => 'accept',
  }
}
