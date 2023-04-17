class php {
  $enhancers = [ 'php', 'php-mysql', 'php-xml', 'php-common', 'php-gd', 'php-mbstring', 
    'php-xmlrpc', 'php-curl', 'php-soap', 'php-zip', 'php-intl', 'libapache2-mod-php',
     'php-redis', 'php-imap', 'php-fpm', 'php-cli', 'php-mysqli']

  file { '/var/www/html/info.php':
    ensure  => present,
    content => template('php/info.php.erb')
  }

  package { $enhancers:
    ensure => installed,
    notify => Service['apache2']
  }

}
