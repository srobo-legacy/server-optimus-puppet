
class jenkins {
    package {"jenkins":
        ensure  => "installed",
        provider => "rpm",
        source => "http://pkg.jenkins-ci.org/redhat/jenkins-1.501-1.1.noarch.rpm",
    }

    service {"jenkins":
        enable  => true,
        ensure  => "running",
        hasrestart=> true,
        require => Package["jenkins"],
    }
}
