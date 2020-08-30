node 'www.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker_config':} ->
  class {'::cloud::natucci_de':}
}

node 'puppet.natucci.de' {
  class {'::cloud::default':}
}
