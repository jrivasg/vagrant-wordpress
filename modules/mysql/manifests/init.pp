class mysql {
 
  package { 'mysql-server':
    ensure => installed,
  }
  
  service { 'mysql':
    ensure => running,
    enable => true,
    require => Package['mysql-server'],
  }
  
  exec { 'crear-db':
    command => "/usr/bin/mysql -u root -p${root_password} -e 'CREATE DATABASE ${wp_db_name};'",
    require => Package['mysql-server'],
    unless => "/usr/bin/mysql -u root -p${root_password} -e 'SHOW DATABASES;' | grep ${wp_db_name}",
  }

  exec { 'crear-usuario':
    command => "/usr/bin/mysql -u root -p${root_password} -e \"CREATE USER '${wp_db_user}'@'${wp_db_host}' IDENTIFIED BY '${wp_password}';\"",
    require => Package['mysql-server'],
    unless => "/usr/bin/mysql -u root -p${root_password} -e \"SELECT User FROM mysql.user;\" | grep ${wp_db_user}",
  }
  
  exec { 'conceder-permisos':
    command => "/usr/bin/mysql -u root -p${root_password} -e \"GRANT ALL PRIVILEGES ON ${wp_db_name}.* TO '${wp_db_user}'@'${wp_db_host}'; FLUSH PRIVILEGES;\"",
    require => Package['mysql-server'],
    unless => "/usr/bin/mysql -u root -p${root_password} -e \"SHOW GRANTS FOR '${wp_db_user}'@'${wp_db_host}';\" | grep ${wp_db_name}",
  }
  
  file { '/root/.my.cnf':
    content => "[client]\nuser=root\npassword=${root_password}\n",
    mode => '0600',
    require => Package['mysql-server'],
  }
}
