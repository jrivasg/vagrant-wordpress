class wordpress {

  exec { 'download':
    cwd => "/tmp",
    command => "wget https://wordpress.org/latest.tar.gz",
    path => ['/usr/bin'],
    creates => "/tmp/wordpress"
  }

  # Copy the Wordpress bundle to /tmp
  file { '/tmp/latest.tar.gz':
    ensure => present,
    require => Exec['download']
  }
  
  # Extract the Wordpress bundle
  exec { 'extract':
    cwd => "/tmp",
    command => "tar -xvzf latest.tar.gz",
    require => File['/tmp/latest.tar.gz'],
    path => ['/bin'],
  }

  # Creamos upgrade directorio para instalar posteriormente el core de wp
  file { '/tmp/wordpress/wp-content/upgrade':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0750',
    require => Exec['extract'],
  }

  # Creamos uploads directorio para descargar e instalar temas posteriormente
  file { '/tmp/wordpress/wp-content/uploads':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0750',
    require => Exec['extract'],
  }
  
  # Copy to /var/www/html
  exec { 'copy':
    command => "cp -r /tmp/wordpress/* /var/www/html",
    require => Exec['extract'],
    path => ['/bin'],
  } 
  
  # Generate the wp-config.php file using the template
  file { '/var/www/html/wp-config.php':
    ensure => present,
    require => Exec['copy'],
    content => template("wordpress/wp-config.php.erb")
  }
}
