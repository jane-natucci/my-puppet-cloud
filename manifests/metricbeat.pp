class cloud::metricbeat {
  file {'/etc/yum.repos.d/elasticsearch.repo':
    ensure  => present,
    source  => 'puppet:///modules/cloud/elasticsearch.repo',
    owner   => 'root',
    mode    => '0644',
  } -> exec {'rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch':
    path => '/usr/bin',
  }

  /* metricbeat */

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

  service {'metricbeat':
    ensure => running,
    enable => true,
    require => [
      Package['metricbeat'],
      Exec['metricbeat modules enable system'],
    ]
  }

  /* filebeat */

  package {'filebeat':
    ensure  => present,
    require => File['/etc/yum.repos.d/elasticsearch.repo'],
  }

  exec {'filebeat modules enable haproxy':
    path    => '/usr/bin:/usr/sbin',
    require => Package['filebeat'],
  }

  file {'/etc/filebeat/filebeat.yml':
    ensure  => file,
    content => template('cloud/filebeat.yml.erb'),
    owner   => 'root',
    mode    => '0600',
    require => [
      Package['filebeat']
    ]
  }

  file {'/etc/filebeat/modules.d/haproxy.yml':
    ensure  => file,
    content => template('cloud/haproxy.yml.erb'),
    owner   => 'root',
    mode    => '0644',
    require => [
      Package['filebeat'],
      Exec['filebeat modules enable haproxy'],
    ]
  }

  exec {'filebeat setup -e && touch /root/filebeat_setup':
    path    => '/usr/bin',
    require => File['/etc/filebeat/filebeat.yml'],
    unless  => 'ls /root/filebeat_setup',
  }

  service {'filebeat':
    ensure => running,
    enable => true,
    require => [
      Package['filebeat'],
      File['/etc/filebeat/filebeat.yml'],
      File['/etc/filebeat/modules.d/haproxy.yml'],
    ]
  }
}
