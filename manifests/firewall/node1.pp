class cloud::firewall::node1 () inherits ::cloud::init {
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
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=${cloud::ip_vpn} port port=18080 accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=${cloud::ip_vpn} port port=18080 accept\"",
    require => Service['firewalld'],
  }

  # yarn node manager
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=${cloud::ip_vpn} port port=8042 accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=${cloud::ip_vpn} port port=8042 accept\"",
    require => Service['firewalld'],
  }

  # everything from node2
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=${cloud::ip_node2} accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=${cloud::ip_node2} accept\"",
    require => Service['firewalld'],
  }

  # everything from node3
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=${cloud::ip_node3} accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=${cloud::ip_node3} accept\"",
    require => Service['firewalld'],
  }

  # everything from dns
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=${cloud::ip_dns} accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=${cloud::ip_dns} accept\"",
    require => Service['firewalld'],
  }

  # everything from ipa
  exec {"firewall-cmd --add-rich-rule=\"rule family=ipv4 source address=${cloud::ip_ipa} accept\"":
    unless  => "firewall-cmd --query-rich-rule=\"rule family=ipv4 source address=${cloud::ip_ipa} accept\"",
    require => Service['firewalld'],
  }
}
