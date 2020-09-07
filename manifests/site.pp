node 'www.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::docker_config':} ->
  class {'::cloud::natucci_de':}
}

node 'jenkins.natucci.de' {
  class {'::cloud::default':} ->
  class {'::cloud::jenkins':}
  /* -> class {'::cloud::docker_config':} */
}
