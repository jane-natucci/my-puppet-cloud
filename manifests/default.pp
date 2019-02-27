class cloud::default {
  Package {ensure => present}

  package {'vim-enhanced':}

  package {'ipa-client':}

  package {'git':}

  package {'telnet':}

  package {'traceroute':}

  package {'firewalld':}

  service {'firewalld':
    ensure => running,
    require => Package['firewalld'];
  }

  service { 'puppet':
    ensure => 'running',
    enable => 'true',
  }

  file {'/root/.ssh/':
    ensure => directory
  }
  
  file {'/root/.ssh/authorized_keys':
    source => 'puppet:///modules/cloud/authorized_keys',
    owner  => 0,
    mode   => '0400',
    ensure => present,
    require => File['/root/.ssh/']
  }
  
  file {'/root/.vimrc':
    source => 'puppet:///modules/cloud/.vimrc',
    owner  => 0,
    ensure => present,
    require => File['/root/.ssh/authorized_keys']
  }
}
