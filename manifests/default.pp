## Default software to install on every node.

class cloud::default {
  Package {ensure => present}

  $dependencies = [
    'wget',
    'net-tools',
    'bind-utils',
    'yum-utils',
    'bash-completion',
    'vim-enhanced',
    'git',
    'telnet',
    'traceroute',
    'firewalld',
    'screen',
    'cockpit'
    ]

  package {$dependencies:}

  -> service {'sshd':
    ensure => running,
    enable => true,
  }

  -> service { 'cockpit':
    ensure => 'running',
    enable => 'true',
  }

  service { 'puppet':
    ensure => 'running',
    enable => 'true',
  }

  file {'/root/.ssh/':
    ensure => directory
  }

  file {'/root/.ssh/authorized_keys':
    ensure  => present,
    source  => 'puppet:///modules/cloud/authorized_keys',
    owner   => 0,
    mode    => '0400',
    require => File['/root/.ssh/']
  }

  file {'/root/.vimrc':
    ensure  => present,
    source  => 'puppet:///modules/cloud/.vimrc',
    owner   => 0,
    require => File['/root/.ssh/authorized_keys']
  }

  wget::fetch {'download github repo':
    source      => 'https://raw.githubusercontent.com/GitAlias/gitalias/master/gitalias.txt',
    destination => '/root/gitalias.txt'
  }

  file {'/root/.gitconfig':
    ensure => present,
    source => 'puppet:///modules/cloud/.gitconfig',
    owner  => 0,
  }
}
