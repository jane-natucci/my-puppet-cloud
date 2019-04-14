class cloud::firewall::node3 () inherits ::cloud::params {
  Exec {path => '/usr/bin'}

  service {'firewalld':
    ensure => running,
    enable => true,
  }

  # ssh
  exec {"firewall-cmd --add-service=ssh":
    unless  => 'firewall-cmd --query-service=ssh',
    require => Service['firewalld'],
  }

  # spark history server
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_vpn port port=18080 protocol=tcp accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_vpn port port=18080 protocol=tcp accept\"",
    require => Service['firewalld'],
  }

  # yarn node manager
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_vpn port port=8042 protocol=tcp accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_vpn port port=8042 protocol=tcp accept\"",
    require => Service['firewalld'],
  }

  # everything from node1
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_node1 accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_node1 accept\"",
    require => Service['firewalld'],
  }

  # everything from node2
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_node2 accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_node2 accept\"",
    require => Service['firewalld'],
  }

  # everything from dns
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_dns accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_dns accept\"",
    require => Service['firewalld'],
  }

  # everything from ipa
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_ipa accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=$::cloud::params::ip_ipa accept\"",
    require => Service['firewalld'],
  }
}
