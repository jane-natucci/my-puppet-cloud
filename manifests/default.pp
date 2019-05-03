class cloud::default {
  Package {ensure => present}

  $dependencies = [
    'epel-release',
    'wget',
    'net-tools',
    'bind-utils',
    'yum-utils',
    'bash-completion',
    'vim-enhanced',
    'git',
    'ipa-client',
    'telnet',
    'traceroute',
    'firewalld',
    'screen'
    ]

  package {$dependencies:} ->

  service {'sshd':
    ensure => running,
    enable => true,
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
