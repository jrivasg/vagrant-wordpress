class apache {
  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }

  /*  Crea una relación entre el comando apt-update y la instalación
   de cada package, se ejecutará antes siempre */
  Exec["apt-update"] -> Package <| |>

  package { 'apache2':
    ensure => installed,
  }

  /* Elimina el archivo de configuración de host virtual predeterminado 
  que se crea automáticamente */
  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure => absent,
    require => Package['apache2'],
  }

  /* Esto crea un nuevo archivo de configuración de host virtual para el 
  nombre de host vagrant utilizando una plantilla ubicada en 
  apache/virtual-hosts.conf.erb. Requiere la eliminación del archivo de 
  configuración de host virtual predeterminado creado en el paso 4. */
  file { '/etc/apache2/sites-available/vagrant.conf':
    content => template('apache/virtual-hosts.conf.erb'),
    require => File['/etc/apache2/sites-enabled/000-default.conf'],
  }

  /* Esto crea un enlace simbólico para habilitar el archivo de configuración
   de host virtual vagrant vinculándolo al directorio sites-enabled. 
   Requiere la creación del archivo de configuración de host virtual vagrant
   creado en el paso anterior, y notifica al servicio apache2 del cambio.  */
  file { "/etc/apache2/sites-enabled/vagrant.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/vagrant.conf",
    require => File['/etc/apache2/sites-available/vagrant.conf'],
    notify  => Service['apache2'],
  }

  file { 'Remove file index':
    path => "${server_root}/index.html",
    ensure => absent,
  }

  /* Esto asegura que el servicio apache2 esté en ejecución y habilitado en 
  el arranque del sistema. También especifica el comando que se ejecutará cuando
  se reinicie el servicio, que prueba la sintaxis del archivo de configuración 
  de Apache y luego recarga el servicio. */
  service { 'apache2':
    ensure => running,
    enable => true,
    hasstatus  => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
  }
}

