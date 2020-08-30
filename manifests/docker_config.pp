class cloud::docker_config {
  Package {ensure => present}
  Exec {path => '/usr/bin:/usr/sbin'}

  exec {'yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'} ->
  package {'docker-ce':} ->
  package {'docker-ce-cli':} ->
  package {'containerd.io':}

  file {'/root/.docker':
    ensure  => directory,
    owner   => 0,
    mode    => '0644',
    require => Package['docker'],
  }

  file {'/root/.docker/config.json':
    ensure  => present,
    source  => 'puppet:///modules/cloud/config.json',
    owner   => 0,
    mode    => '0644',
    require => [
      File['/root/.docker/'],
      Package['docker'],
    ]
  }

  file {'/etc/docker/daemon.json':
    ensure  => present,
    source  => 'puppet:///modules/cloud/daemon.json',
    owner   => 0,
    mode    => '0644',
    require => Package['docker'],
  }

  service {'docker':
    ensure  => 'running',
    enable  => true,
    require => [
      File['/etc/docker/daemon.json'],
      File['/root/.docker/config.json'],
      Package['docker']
    ]
  }
}
