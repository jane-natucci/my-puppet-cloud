class cloud::elasticsearch {
  file {'/etc/yum.repos.d/elasticsearch.repo':
    ensure  => present,
    source  => 'puppet:///modules/cloud/elasticsearch.repo',
    owner   => 'root',
    mode    => '0644',
  }

  exec {'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch':
    path => '/usr/bin',
  } ->
  package {'elasticsearch':
    require => File['/etc/yum.repos.d/elasticsearch.repo'],
    ensure  => present,
  } ->
  service {'elasticsearch':
    ensure => running,
    enable => true,
  }
}
