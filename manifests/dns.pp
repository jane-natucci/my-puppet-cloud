class cloud::dns {
  file { "/home/git/.ssh/":
    owner  => "git",
    mode   => "0644",
    ensure => directory
  } -> file { "/home/git/.ssh/authorized_keys":
    source => "puppet:///modules/cloud/authorized_keys",
    owner  => "git",
    mode   => "0400",
    ensure => present
  }
}
