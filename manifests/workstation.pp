class cloud::workstation {
  Package {ensure => present}

  package {'awscli':}

  wget::fetch {'download gitlab repo':
    source      => 'https://raw.githubusercontent.com/GitAlias/gitalias/master/gitalias.txt',
    destination => '/root/gitalias.txt'
  }

  file {'/root/.gitconfig':
    source => 'puppet:///modules/cloud/.gitconfig',
    owner  => 0,
    ensure => present,
  }
}
