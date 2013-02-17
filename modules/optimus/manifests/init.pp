# Root this-is-optimus config file.
# Fans out to different kinds of services optimus hosts.

# git_root: The root URL to access the SR git repositories
class optimus( ) {

  # Default PATH
  Exec {
    path => [ "/usr/bin" ],
  }

  # Directory for 'installed flags' for various flavours of data. When some
  # piece of data is loaded from backup/wherever into a database, files here
  # act as a guard against data being reloaded.
  file { '/usr/local/var':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '755',
  }

  file { '/usr/local/var/sr':
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '700',
    require => File['/usr/local/var'],
  }

  # Jenkins CI
  include jenkins

  # The plugins we want (we need to explicitly fulfill the dependencies!)
  jenkins::plugin {
    "git": ;
    "gerrit-trigger": ;
  }
}
