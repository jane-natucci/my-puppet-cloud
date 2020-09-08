node 'www.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker':} ->
  class {'::cloud::www':} ->
  class {'::cloud::firewall::www':}
}

node 'puppet.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker':} ->
  class {'::cloud::firewall::puppet':}
}
