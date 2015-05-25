# == Class: single_user_rvm::dependencies
#
# Install packages required for a proper RVM installation.
#
# These should preferably be broken down to subclasses for each os, arch and/or ruby and be respectively required.
# However I don't really care for that currently :) In case of weird configurations I would preferably specify those
# dependencies somewhere else since it would be a far fetched exception for me. Feel free to contribute to it though!
#
# Current package lists taken from https://github.com/wayneeseguin/rvm/blob/master/scripts/functions/requirements/ubuntu
#
# Not needed for public use, it will be required before installing RVM on it's own
#
class single_user_rvm::dependencies inherits single_user_rvm {

  # RVM dependencies
  if ! defined(Package['bash'])            { package { 'bash':            ensure => present } }
  if ! defined(Package['curl'])            { package { 'curl':            ensure => present } }
  if ! defined(Package['patch'])           { package { 'patch':           ensure => present } }
  if ! defined(Package['bzip2'])           { package { 'bzip2':           ensure => present } }
  if ! defined(Package['ca-certificates']) { package { 'ca-certificates': ensure => present } }
  if ! defined(Package['gawk'])            { package { 'gawk':            ensure => present } }

  # Generic Ruby dependencies
  if ! defined(Package['g++'])              { package { 'g++':              ensure => present } }
  if ! defined(Package['gcc'])              { package { 'gcc':              ensure => present } }
  if ! defined(Package['make'])             { package { 'make':             ensure => present } }
  if ! defined(Package['libc6-dev'])        { package { 'libc6-dev':        ensure => present } }
  if ! defined(Package['patch'])            { package { 'patch':            ensure => present } }
  if ! defined(Package['openssl'])          { package { 'openssl':          ensure => present } }
  if ! defined(Package['ca-certificates'])  { package { 'ca-certificates':  ensure => present } }
  if ! defined(Package['libreadline6'])     { package { 'libreadline6':     ensure => present } }
  if ! defined(Package['libreadline6-dev']) { package { 'libreadline6-dev': ensure => present } }
  if ! defined(Package['curl'])             { package { 'curl':             ensure => present } }
  if ! defined(Package['zlib1g'])           { package { 'zlib1g':           ensure => present } }
  if ! defined(Package['zlib1g-dev'])       { package { 'zlib1g-dev':       ensure => present } }
  if ! defined(Package['libssl-dev'])       { package { 'libssl-dev':       ensure => present } }
  if ! defined(Package['libyaml-dev'])      { package { 'libyaml-dev':      ensure => present } }
  if ! defined(Package['libsqlite3-dev'])   { package { 'libsqlite3-dev':   ensure => present } }
  if ! defined(Package['sqlite3'])          { package { 'sqlite3':          ensure => present } }
  if ! defined(Package['autoconf'])         { package { 'autoconf':         ensure => present } }
  if ! defined(Package['libgdbm-dev'])      { package { 'libgdbm-dev':      ensure => present } }
  if ! defined(Package['libncurses5-dev'])  { package { 'libncurses5-dev':  ensure => present } }
  if ! defined(Package['automake'])         { package { 'automake':         ensure => present } }
  if ! defined(Package['libtool'])          { package { 'libtool':          ensure => present } }
  if ! defined(Package['bison'])            { package { 'bison':            ensure => present } }
  if ! defined(Package['pkg-config'])       { package { 'pkg-config':       ensure => present } }
  if ! defined(Package['libffi-dev'])       { package { 'libffi-dev':       ensure => present } }

}
