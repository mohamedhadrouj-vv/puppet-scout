class scout ($display_name=$hostname, $roles_list='', $user='scout', $key) {

  package {['mysql', 'mysql-devel', 'libcurl-devel']:
    ensure   => 'installed',
    provider => 'yum',
  }

  package {['scout', 'SystemTimer', 'elif', 'request-log-analyzer', 'curb', 'mysql']:
      ensure   => 'installed',
      provider => 'gem',
      # mysql gem requires both mysql and mysql-devel packages
      require  => Package['mysql', 'mysql-devel', 'libcurl-devel']
  }

  if $display_name {
    $option_displayname = "--name='${display_name}'"
  }

  if $roles_list != '' {
    $option_roles = "--roles ${roles_list}"
  }

  cron {
    'scout':
      command   => "/usr/bin/scout ${option_displayname} ${option_roles} ${key}",
      user	    => $user,
      require   => Package['scout'],
  }

}
