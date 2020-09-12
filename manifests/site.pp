node 'www.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker':} ->
  class {'::cloud::www':} ->
  class {'::cloud::firewall::www':}
}

node 'puppet.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker':} ->
  class {'::cloud::jenkins':} ->
  class {'::cloud::firewall::puppet':}
}

node 'elastic.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::elastic':}
}
