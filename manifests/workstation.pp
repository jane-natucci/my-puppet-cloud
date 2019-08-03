class cloud::workstation {
  Package {ensure => present}

  package {'awscli':}
}
