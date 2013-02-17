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

  # Checkout of jenkins configs
  $jenkins_root = "/var/lib/jenkins"
  vcsrepo { "${jenkins_root}":
    ensure => present,
    provider => git,
    source => "${git_root}/server/jenkins-config.git",
    revision => "origin/master",
    force => true,
  }

  # Jenkins CI
  include jenkins

  # The plugins we want (we need to explicitly fulfill the dependencies!)
  jenkins::plugin {
    "git": ;
    "gerrit-trigger": ;
  }

  file { "${jenkins_root}/.ssh":
    ensure => directory,
    owner => 'jenkins',
    group => 'jenkins',
    mode => '700',
    require => [Vcsrepo["${jenkins_root}"],Class["jenkins::package"]]
  }

  exec { 'jenkins-ssh-keys':
    command => "ssh-keygen -N '' -f ${jenkins_root}/.ssh/id_rsa",
    creates => ["${jenkins_root}/.ssh/id_rsa","${jenkins_root}/.ssh/id_rsa.pub"],
    require => [Vcsrepo["${jenkins_root}"],File["${jenkins_root}/.ssh"],Class["jenkins::package"]]
  }

  exec { 'fix-jenkins-ownership':
    command => "chown -R jenkins: ${jenkins_root}",
    require => [Vcsrepo["${jenkins_root}"],Class["jenkins::package"],Exec['jenkins-ssh-keys']]
  }

}
