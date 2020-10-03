class cloud::metricbeat {
  file {'/etc/yum.repos.d/elasticsearch.repo':
    ensure  => present,
    source  => 'puppet:///modules/cloud/elasticsearch.repo',
    owner   => 'root',
    mode    => '0644',
  } -> exec {'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch':
    path => '/usr/bin',
  }

  package {'metricbeat':
    ensure  => present,
    require => File['/etc/yum.repos.d/elasticsearch.repo'],
  }

  exec {'metricbeat modules enable system':
    path    => '/usr/bin:/usr/sbin',
    require => Package['metricbeat'],
  }

  file {'/etc/metricbeat/metricbeat.yml':
    ensure  => file,
    content => template('cloud/metricbeat.yml.erb'),
    owner   => 'root',
    mode    => '0600',
    require => [
      Package['metricbeat']
    ]
  }

  /*
  service {'metricbeat':
    ensure => running,
    enable => true,
    require => [
      Package['metricbeat']
      Exec['metricbeat modules enable system'],
    ]
  }
  */
}
