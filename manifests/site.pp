node 'www.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::www':}
}

node 'puppet.natucci.de' {
  class {'::cloud::default':}
}
