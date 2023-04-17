class wpcli {

  exec { 'download-wpcli':
    cwd => "/tmp",
    command => "wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
    path => ['/usr/bin'],
    #creates => "/usr/local/bin/wp",
  }

  exec { 'copy-wpcli':
    command => "mv /tmp/wp-cli.phar /usr/local/bin/wp",
    require => Exec['download-wpcli'],
    path => ['/bin'],
  } 
  

  exec { 'permisos-ejecucion':
    command => "chmod +x /usr/local/bin/wp",
    require => Exec['download-wpcli'],
    path => ['/bin'],
  } 
 
  /* exec { 'Basic config':
    command => "wp core install --url=localhost:80 --locale=es_ES --title='El blog de Ilich Morales UNIR' --admin_name=${wp_admin} --admin_password=${wp_password} --admin_email=jrivasgonzalez@gmail.com --allow-root --path='${server_root}'",
    require => Exec['permisos-ejecucion'],
    path => ['/usr/local/bin'],
    notify => Service['apache2']
  }

  exec { 'Install theme':
    command => "wp theme install twentyseventeen  --allow-root --path='${server_root}' --activate",
    path => ['/usr/local/bin'],
    require => Exec['Basic config']
  }

  notify {'WP-CLI-Installed':
    message => "Module WP-CLI installed...",
    require => Exec['Install theme']
  } */
}
