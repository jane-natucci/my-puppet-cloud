class cloud::filebeat {
  file {'/etc/yum.repos.d/elasticsearch.repo':
    ensure  => present,
    source  => 'puppet:///modules/cloud/elasticsearch.repo',
    owner   => 'root',
    mode    => '0644',
  } -> exec {'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch':
    path => '/usr/bin',
  }

  package {'filebeat':
    ensure  => present,
    require => File['/etc/yum.repos.d/elasticsearch.repo'],
  }

  /*
  file {'/etc/filebeat/filebeat.yml':
    ensure  => file,
    content => template('cloud/filebeat.yml.erb'),
    owner   => 'root',
    mode    => '0600',
    require => [
      Package['filebeat']
    ]
  }

  service {'filebeat':
    ensure => running,
    enable => true,
    require => [
      Package['filebeat'],
    ]
  }
  */
}
