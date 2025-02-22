# @summary
#   This is a container class with default parameters for monit classes.
#
# @api private
class monit::params {
  $check_interval            = 120
  $config_dir_purge          = false
  $httpd                     = false
  $httpd_port                = 2812
  $httpd_address             = 'localhost'
  $httpd_allow               = '0.0.0.0/0.0.0.0'
  $httpd_user                = 'admin'
  $httpd_password            = 'monit'
  $manage_firewall           = false
  $package_ensure            = 'present'
  $package_name              = 'monit'
  $service_enable            = true
  $service_ensure            = 'running'
  $service_manage            = true
  $service_name              = 'monit'
  $logfile                   = '/var/log/monit.log'
  $mailserver                = undef
  $mailformat                = undef
  $alert_emails              = []
  $start_delay               = undef
  $mmonit_address            = undef
  $mmonit_https              = true
  $mmonit_port               = 8443
  $mmonit_user               = 'monit'
  $mmonit_password           = 'monit'
  $mmonit_without_credential = false

  # <OS family handling>
  case $::osfamily {
    'Debian': {
      $config_file   = '/etc/monit/monitrc'
      $config_dir    = '/etc/monit/conf.d'
      $monit_version = '5'

      case $::lsbdistcodename {
        'squeeze', 'lucid': {
          $default_file_content = 'startup=1'
          $service_hasstatus    = false
        }
        'wheezy', 'jessie', 'stretch', 'buster', 'precise', 'trusty', 'xenial', 'bionic', 'jammy': {
          $default_file_content = 'START=yes'
          $service_hasstatus    = true
        }
        default: {
          fail("monit supports Debian 6 (squeeze), 7 (wheezy), 8 (jessie), 9 (stretch) and 10 (buster) \
and Ubuntu 10.04 (lucid), 12.04 (precise), 14.04 (trusty), 16.04 (xenial) and 18.04 (bionic). \
Detected lsbdistcodename is <${::lsbdistcodename}>.")
        }
      }
    }
    'RedHat': {
      $config_dir        = '/etc/monit.d'
      $service_hasstatus = true

      case $::operatingsystem {
        'Amazon': {
          case $::operatingsystemmajrelease {
            '2016', '2018': {
              $monit_version = '5'
              $config_file   = '/etc/monit.conf'
            }
            default: {
              fail("monit supports Amazon Linux 2. Detected operatingsystemmajrelease is <${::operatingsystemmajrelease}>.")
            }
          }
        }
        default: {
          case $::operatingsystemmajrelease {
            '5': {
              $monit_version = '4'
              $config_file   = '/etc/monit.conf'
            }
            '6': {
              $monit_version = '5'
              $config_file   = '/etc/monit.conf'
            }
            '7', '8': {
              $monit_version = '5'
              $config_file   = '/etc/monitrc'
            }
            default: {
              fail("monit supports EL 5, 6 and 7. Detected operatingsystemmajrelease is <${::operatingsystemmajrelease}>.")
            }
          }
        }
      }
    }
    default: {
      fail("monit supports osfamilies Debian and RedHat. Detected osfamily is <${::osfamily}>.")
    }
  }
  # </OS family handling>
}
