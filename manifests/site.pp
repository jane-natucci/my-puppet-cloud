## Assignment of classes to nodes.

node 'www.natucci.de' {
  include ::cloud::params

  class {'::cloud::default':}
  -> class {'::cloud::docker':}
  -> class {'::cloud::www':}
  -> class {'::cloud::metricbeat':}
  -> class {'::cloud::firewall::www':}
}

node 'puppet.natucci.de' {
  include ::cloud::params

  class {'::cloud::default':}
  -> class {'::cloud::docker':}
  -> class {'::cloud::jenkins':}
  -> class {'::cloud::firewall::puppet':}
}

node 'elasticsearch.natucci.de' {
  include ::cloud::params

  class {'::cloud::default':}
  -> class {'::cloud::elasticsearch':}
  -> class {'::cloud::firewall::elasticsearch':}
}
