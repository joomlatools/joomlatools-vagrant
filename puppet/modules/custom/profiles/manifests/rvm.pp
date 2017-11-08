class profiles::rvm {

  gnupg_key { 'gpg-rvm-signature':
    ensure     => present,
    key_id     => 'D39DC0E3',
    user       => 'vagrant',
    key_source => 'https://rvm.io/mpapis.asc',
    key_type   => public,
  }

  single_user_rvm::install { 'vagrant':
    version => latest,
    require => Gnupg_key['gpg-rvm-signature']
  }

  single_user_rvm::install_ruby { 'ruby-2.2.6':
    user => vagrant
  }

  exec {'set-default-ruby-for-vagrant':
    user        => vagrant,
    command     => 'bash -c "source ~/.rvm/scripts/rvm; rvm --default use 2.2.6"',
    unless      => '/home/vagrant/.rvm/bin/rvm list | grep "* ruby-2.2.6"',
    environment => ['HOME=/home/vagrant'],
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/vagrant/.rvm/bin/',
    require     => Single_user_rvm::Install_ruby['ruby-2.2.6']
  }

}