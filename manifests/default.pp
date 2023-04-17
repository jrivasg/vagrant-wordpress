$document_root = '/home/vagrant'
$server_root = '/var/www/html'
$root_password = 'StrongPassword0' 
$wp_db_name = 'wordpress'
$wp_db_user = 'wp_db_user'
$wp_password = 'wp_password'
$wp_db_host = 'localhost'
$wp_admin = 'wp_admin'

include apache
include php
include mysql
include wordpress
include wpcli

notify { 'Showing machine Facts':
  message => "Machine with ${::memory['system']['total']} of memory and $::processorcount processor/s.
              Please check access to http://$::ipaddress_enp0s8}",
}
