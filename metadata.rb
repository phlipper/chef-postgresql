name             "postgresql"
maintainer       "Phil Cohen"
maintainer_email "github@phlippers.net"
license          "MIT"
description      "Installs PostgreSQL, The world's most advanced open source database."
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.13.0"

recipe "postgresql",                   "Set up the apt repository and install dependent packages"
recipe "postgresql::apt_repository",   "Internal recipe to setup the apt repository"
recipe "postgresql::client",           "Front-end programs for PostgreSQL 9.x"
recipe "postgresql::configuration",    "Internal recipe to manage configuration files"
recipe "postgresql::contrib",          "Additional facilities for PostgreSQL"
recipe "postgresql::data_directory",   "Internal recipe to setup the data directory"
recipe "postgresql::dbg",              "Debug symbols for the server daemon"
recipe "postgresql::debian_backports", "Internal recipe to manage debian backports"
recipe "postgresql::doc",              "Documentation for the PostgreSQL database management system"
recipe "postgresql::libpq",            "PostgreSQL C client library and header files for libpq5 (PostgreSQL library)"
recipe "postgresql::pg_database",      "Internal recipe to manage specified databases"
recipe "postgresql::pg_user",          "Internal recipe to manage specified users"
recipe "postgresql::postgis",          "Geographic objects support for PostgreSQL 9.x"
recipe "postgresql::server",           "Object-relational SQL database, version 9.x server"
recipe "postgresql::server_dev",       "Development files for PostgreSQL server-side programming"
recipe "postgresql::service",          "Internal recipe to declare the system service"

%w[ubuntu debian].each do |os|
  supports os
end

depends "apt"
