# chef-postgresql

## Flair

![Cookbook Version](https://img.shields.io/badge/cookbook-0.16.1-blue.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](http://phlipper.mit-license.org/2012-2015/license.html)
[![Build Status](http://img.shields.io/travis-ci/phlipper/chef-postgresql.png)](https://travis-ci.org/phlipper/chef-postgresql)
[![Gitter](https://img.shields.io/badge/Gitter%2Eim-Join_Chat_→-yellow.svg)](https://gitter.im/phlipper/chef-postgresql)
![It Works On My Machine™](https://img.shields.io/badge/It_Works-On_My_Machine%E2%84%A2-orange.svg)
[![Tip](http://img.shields.io/gratipay/phlipper.png)](https://gratipay.com/phlipper/)
[![Endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper)

## Description

Installs [PostgreSQL](http://www.postgresql.org), The world's most advanced open source database.

This installs postgres 9.x from the [PostgreSQL Apt Repository](https://wiki.postgresql.org/wiki/Apt).

Currently supported versions:

* `9.0`
* `9.1`
* `9.2`
* `9.3`
* `9.4`

The default version is `9.4`.

## Requirements

### Supported Platforms

The following platforms are supported by this cookbook, meaning that the recipes run on these platforms without error:

* Debian 7.8
* Ubuntu 12.04
* Ubuntu 14.04

### Chef

This cookbook requires Chef >= 11.13 due to the use of the `sensitive` attribute for some resources.

### Cookbooks

* [apt](http://community.opscode.com/cookbooks/apt)
* [minitest-handler](http://community.opscode.com/cookbooks/minitest-handler) _(suggested, not required)_


## Recipes

* `postgresql` - Set up the apt repository and install dependent packages
* `postgresql::apt_repository` - Internal recipe to setup the apt repository
* `postgresql::client` - Front-end programs for PostgreSQL 9.x
* `postgresql::configuration` - Internal recipe to manage configuration files
* `postgresql::contrib` - Additional facilities for PostgreSQL
* `postgresql::data_directory` - Internal recipe to setup the data directory
* `postgresql::dbg` - Debug symbols for the server daemon
* `postgresql::debian_backports` - Internal recipe to manage debian backports
* `postgresql::doc` - Documentation for the PostgreSQL database management system
* `postgresql::libpq` - PostgreSQL C client library and header files for libpq5 (PostgreSQL library)
* `postgresql::postgis` - Geographic objects support for PostgreSQL 9.x _(currently Ubuntu only)_
* `postgresql::server` - Object-relational SQL database, version 9.x server
* `postgresql::server_dev` - Development files for PostgreSQL server-side programming
* `postgresql::service` - Internal recipe to declare the system service
* `postgresql::setup_databases` - Internal recipe to manage specified databases
* `postgresql::setup_extensions` - Internal recipe to manage specified database extensions
* `postgresql::setup_languages` - Internal recipe to manage specified database languages
* `postgresql::setup_users` - Internal recipe to manage specified users


## Usage

This cookbook installs the postgresql components if not present, and pulls updates if they are installed on the system.

This cookbook provides three definitions to create, alter, and delete users as well as create and drop databases, or setup extensions. Usage is as follows:


### Users

```ruby
# create a user
postgresql_user "myuser" do
  superuser false
  createdb false
  login true
  replication false
  password "mypassword"
end

# create a user with an MD5-encrypted password
postgresql_user "myuser" do
  superuser false
  createdb false
  login true
  replication false
  encrypted_password "667ff118ef6d196c96313aeaee7da519"
end

# drop a user
postgresql_user "myuser" do
  action :drop
end
```

Or add users via attributes:

```json
"postgresql": {
  "users": [
    {
      "username": "dickeyxxx",
      "password": "password",
      "superuser": true,
      "replication": false,
      "createdb": true,
      "createrole": false,
      "inherit": true,
      "replication": false,
      "login": true
    }
  ]
}
```

### Databases and Extensions

```ruby
# create a database
postgresql_database "mydb" do
  owner "myuser"
  encoding "UTF-8"
  template "template0"
  locale "en_US.UTF-8"
end

# install extensions to database
postgresql_extension "hstore" do
  database "mydb"
end

postgresql_language "plpgsql" do
  database "mydb"
end

# drop dblink extension
postgresql_extension "dblink" do
  database "mydb"
  action :drop
end

# drop a database
postgresql_database "mydb" do
  action :drop
end
```

Or add the database via attributes:

```json
"postgresql": {
  "databases": [
    {
      "name": "my_db",
      "owner": "dickeyxxx",
      "template": "template0",
      "encoding": "UTF-8",
      "locale": "en_US.UTF-8",
      "extensions": ["hstore", "dblink"],
      "postgis": true
    }
  ]
}
```

### Configuration

The `postgresql.conf` configuration may be set one of two ways:

* set individual node attributes to be interpolated into the default template
* create a custom configuration hash to write a custom file

To create a custom configuration, set the `node["postgresql"]["conf"]` hash with your custom settings:

```json
"postgresql": {
  "conf": {
    "data_directory": "/dev/null",
    // ... all options explicitly set here
  }
}
```

You may also set the contents of `pg_hba.conf` via attributes:

```json
"postgresql": {
  "pg_hba": [
    { "type": "local", "db": "all", "user": "postgres",   "addr": "",             "method": "ident" },
    { "type": "local", "db": "all", "user": "all",        "addr": "",             "method": "trust" },
    { "type": "host",  "db": "all", "user": "all",        "addr": "127.0.0.1/32", "method": "trust" },
    { "type": "host",  "db": "all", "user": "all",        "addr": "::1/128",      "method": "trust" },
    { "type": "host",  "db": "all", "user": "postgres",   "addr": "127.0.0.1/32", "method": "trust" },
    { "type": "host",  "db": "all", "user": "username",   "addr": "127.0.0.1/32", "method": "trust" }
  ]
}
```

### Change APT distribution

Currently the APT distributions are sourced from [http://apt.postgresql.org/pub/repos/apt/](http://apt.postgresql.org/pub/repos/apt/).
In some cases this source might not immediately contain a package for the distribution of your target system.

The `node["postgresql"]["apt_distribution"]` attribute can be used to install PostgreSQL from a different compatible
distribution:

```json
"postgresql": {
  "apt_distribution": "precise"
}
```

## Attributes

```ruby
# WARNING: If this version number is changed in your own recipes, the
# FILE LOCATIONS (see below) attributes *must* also be overridden in
# order to re-compute the paths with the correct version number.
default["postgresql"]["version"]                         = "9.4"

#----------------------------------------------------------------------------
# DAEMON CONTROL
#----------------------------------------------------------------------------
default["postgresql"]["service_actions"]                 = %w[enable start]

# control how the postgres service is signaled when configuration files are
# updated. by default the service is told to `:restart` (stop, start). if you
# run high availability installation and do not want the service to restart via
# chef you can change this to `:reload`. the caveat is that you will need to
# manually restart the postgres server if you change a setting that requires
# a full restart.
default["postgresql"]["cfg_update_action"]               = :restart

#----------------------------------------------------------------------------
# APT REPOSITORY
#----------------------------------------------------------------------------
default["postgresql"]["apt_distribution"]                = node["lsb"]["codename"]
default["postgresql"]["apt_repository"]                  = "apt.postgresql.org"
default["postgresql"]["apt_uri"]                         = "http://apt.postgresql.org/pub/repos/apt"
default["postgresql"]["apt_components"]                  = ["main"]
default["postgresql"]["apt_key"]                         = "https://www.postgresql.org/media/keys/ACCC4CF8.asc"
# You can set default["postgresql"]["apt_keyserver"] if you want to use a keyserver

default["postgresql"]["environment_variables"]           = {}
default["postgresql"]["pg_ctl_options"]                  = ""
default["postgresql"]["pg_hba"]                          = []
default["postgresql"]["pg_hba_defaults"]                 = true  # Whether to populate the pg_hba.conf with defaults
default["postgresql"]["pg_ident"]                        = []
default["postgresql"]["start"]                           = "auto"  # auto, manual, disabled

default["postgresql"]["conf"]                            = {}
default["postgresql"]["conf_custom"]                     = false  # if true, only use node["postgresql"]["conf"]
default["postgresql"]["initdb_options"]                  = "--locale=en_US.UTF-8"

#------------------------------------------------------------------------------
# FILE LOCATIONS
#------------------------------------------------------------------------------
default["postgresql"]["data_directory"]                  = "/var/lib/postgresql/#{node["postgresql"]["version"]}/main"
default["postgresql"]["hba_file"]                        = "/etc/postgresql/#{node["postgresql"]["version"]}/main/pg_hba.conf"
default["postgresql"]["ident_file"]                      = "/etc/postgresql/#{node["postgresql"]["version"]}/main/pg_ident.conf"
default["postgresql"]["external_pid_file"]               = "/var/run/postgresql/#{node["postgresql"]["version"]}-main.pid"


#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# connection settings
default["postgresql"]["listen_addresses"]                = "localhost"
default["postgresql"]["port"]                            = 5432
default["postgresql"]["max_connections"]                 = 100
default["postgresql"]["superuser_reserved_connections"]  = 3
default["postgresql"]["unix_socket_group"]               = ""
default["postgresql"]["unix_socket_permissions"]         = "0777"
default["postgresql"]["bonjour"]                         = "off"
default["postgresql"]["bonjour_name"]                    = ""

if Gem::Version.new(node["postgresql"]["version"]) >= Gem::Version.new("9.3")
  default["postgresql"]["unix_socket_directories"]       = "/var/run/postgresql"
else
  default["postgresql"]["unix_socket_directory"]         = "/var/run/postgresql"
end

# security and authentication
default["postgresql"]["authentication_timeout"]          = "1min"
default["postgresql"]["ssl"]                             = true
default["postgresql"]["ssl_ciphers"]                     = "ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH"
default["postgresql"]["ssl_renegotiation_limit"]         = "512MB"
default["postgresql"]["ssl_ca_file"]                     = ""
default["postgresql"]["ssl_cert_file"]                   = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
default["postgresql"]["ssl_crl_file"]                    = ""
default["postgresql"]["ssl_key_file"]                    = "/etc/ssl/private/ssl-cert-snakeoil.key"
default["postgresql"]["password_encryption"]             = "on"
default["postgresql"]["db_user_namespace"]               = "off"

# kerberos and gssapi
default["postgresql"]["db_user_namespace"]               = "off"
default["postgresql"]["krb_server_keyfile"]              = ""
default["postgresql"]["krb_srvname"]                     = "postgres"
default["postgresql"]["krb_caseins_users"]               = "off"

# tcp keepalives
default["postgresql"]["tcp_keepalives_idle"]             = 0
default["postgresql"]["tcp_keepalives_interval"]         = 0
default["postgresql"]["tcp_keepalives_count"]            = 0


#------------------------------------------------------------------------------
# RESOURCE USAGE (except WAL)
#------------------------------------------------------------------------------

# memory
default["postgresql"]["shared_buffers"]                  = "24MB"
default["postgresql"]["temp_buffers"]                    = "8MB"
default["postgresql"]["max_prepared_transactions"]       = 0
default["postgresql"]["work_mem"]                        = "1MB"
default["postgresql"]["maintenance_work_mem"]            = "16MB"
default["postgresql"]["max_stack_depth"]                 = "2MB"

# kernel resource usage
default["postgresql"]["max_files_per_process"]           = 1000
default["postgresql"]["shared_preload_libraries"]        = ""

# cost-based vacuum delay
default["postgresql"]["vacuum_cost_delay"]               = "0ms"
default["postgresql"]["vacuum_cost_page_hit"]            = 1
default["postgresql"]["vacuum_cost_page_miss"]           = 10
default["postgresql"]["vacuum_cost_page_dirty"]          = 20
default["postgresql"]["vacuum_cost_limit"]               = 200

# background writer
default["postgresql"]["bgwriter_delay"]                  = "200ms"
default["postgresql"]["bgwriter_lru_maxpages"]           = 100
default["postgresql"]["bgwriter_lru_multiplier"]         = 2.0

# asynchronous behavior
default["postgresql"]["effective_io_concurrency"]        = 1


#------------------------------------------------------------------------------
# WRITE AHEAD LOG
#------------------------------------------------------------------------------

# settings
default["postgresql"]["wal_level"]                       = "minimal"
default["postgresql"]["fsync"]                           = "on"
default["postgresql"]["synchronous_commit"]              = "on"
default["postgresql"]["wal_sync_method"]                 = "fsync"
default["postgresql"]["full_page_writes"]                = "on"
default["postgresql"]["wal_buffers"]                     = -1
default["postgresql"]["wal_writer_delay"]                = "200ms"
default["postgresql"]["commit_delay"]                    = 0
default["postgresql"]["commit_siblings"]                 = 5

# checkpoints
default["postgresql"]["checkpoint_segments"]             = 3
default["postgresql"]["checkpoint_timeout"]              = "5min"
default["postgresql"]["checkpoint_completion_target"]    = 0.5
default["postgresql"]["checkpoint_warning"]              = "30s"

# archiving
default["postgresql"]["archive_mode"]                    = "off"
default["postgresql"]["archive_command"]                 = ""
default["postgresql"]["archive_timeout"]                 = 0


#------------------------------------------------------------------------------
# REPLICATION
#------------------------------------------------------------------------------

# master server
default["postgresql"]["max_wal_senders"]                 = 0
default["postgresql"]["wal_sender_delay"]                = "1s"
default["postgresql"]["wal_keep_segments"]               = 0
default["postgresql"]["vacuum_defer_cleanup_age"]        = 0
default["postgresql"]["replication_timeout"]             = "60s"
default["postgresql"]["synchronous_standby_names"]       = ""

# standby servers
default["postgresql"]["hot_standby"]                     = "off"
default["postgresql"]["max_standby_archive_delay"]       = "30s"
default["postgresql"]["max_standby_streaming_delay"]     = "30s"
default["postgresql"]["wal_receiver_status_interval"]    = "10s"
default["postgresql"]["hot_standby_feedback"]            = "off"


#------------------------------------------------------------------------------
# QUERY TUNING
#------------------------------------------------------------------------------

# planner method configuration
default["postgresql"]["enable_bitmapscan"]               = "on"
default["postgresql"]["enable_hashagg"]                  = "on"
default["postgresql"]["enable_hashjoin"]                 = "on"
default["postgresql"]["enable_indexscan"]                = "on"
default["postgresql"]["enable_material"]                 = "on"
default["postgresql"]["enable_mergejoin"]                = "on"
default["postgresql"]["enable_nestloop"]                 = "on"
default["postgresql"]["enable_seqscan"]                  = "on"
default["postgresql"]["enable_sort"]                     = "on"
default["postgresql"]["enable_tidscan"]                  = "on"

# planner cost constants
default["postgresql"]["seq_page_cost"]                   = 1.0
default["postgresql"]["random_page_cost"]                = 4.0
default["postgresql"]["cpu_tuple_cost"]                  = 0.01
default["postgresql"]["cpu_index_tuple_cost"]            = 0.005
default["postgresql"]["cpu_operator_cost"]               = 0.0025
default["postgresql"]["effective_cache_size"]            = "128MB"

# genetic query optimizer
default["postgresql"]["geqo"]                            = "on"
default["postgresql"]["geqo_threshold"]                  = 12
default["postgresql"]["geqo_effort"]                     = 5
default["postgresql"]["geqo_pool_size"]                  = 0
default["postgresql"]["geqo_generations"]                = 0
default["postgresql"]["geqo_selection_bias"]             = 2.0
default["postgresql"]["geqo_seed"]                       = 0.0

# other planner options
default["postgresql"]["default_statistics_target"]       = 100
default["postgresql"]["constraint_exclusion"]            = "partition"
default["postgresql"]["cursor_tuple_fraction"]           = 0.1
default["postgresql"]["from_collapse_limit"]             = 8
default["postgresql"]["join_collapse_limit"]             = 8


#------------------------------------------------------------------------------
# ERROR REPORTING AND LOGGING
#------------------------------------------------------------------------------

# where to log
default["postgresql"]["log_destination"]                 = "stderr"
default["postgresql"]["logging_collector"]               = "off"
default["postgresql"]["log_directory"]                   = "pg_log"
default["postgresql"]["log_filename"]                    = "postgresql-%Y-%m-%d_%H%M%S.log"
default["postgresql"]["log_file_mode"]                   = 0600
default["postgresql"]["log_truncate_on_rotation"]        = "off"
default["postgresql"]["log_rotation_age"]                = "1d"
default["postgresql"]["log_rotation_size"]               = "10MB"

# These are relevant when logging to syslog:
default["postgresql"]["syslog_facility"]                 = "LOCAL0"
default["postgresql"]["syslog_ident"]                    = "postgres"
default["postgresql"]["silent_mode"]                     = "off"

# when to log
default["postgresql"]["client_min_messages"]             = "notice"
default["postgresql"]["log_min_messages"]                = "warning"
default["postgresql"]["log_min_error_statement"]         = "error"
default["postgresql"]["log_min_duration_statement"]      = -1

# what to log
default["postgresql"]["debug_print_parse"]               = "off"
default["postgresql"]["debug_print_rewritten"]           = "off"
default["postgresql"]["debug_print_plan"]                = "off"
default["postgresql"]["debug_pretty_print"]              = "on"
default["postgresql"]["log_checkpoints"]                 = "off"
default["postgresql"]["log_connections"]                 = "off"
default["postgresql"]["log_disconnections"]              = "off"
default["postgresql"]["log_duration"]                    = "off"
default["postgresql"]["log_error_verbosity"]             = "default"
default["postgresql"]["log_hostname"]                    = "off"
default["postgresql"]["log_line_prefix"]                 = "%t "
default["postgresql"]["log_lock_waits"]                  = "off"
default["postgresql"]["log_statement"]                   = "none"
default["postgresql"]["log_temp_files"]                  = -1
default["postgresql"]["log_timezone"]                    = "(defaults to server environment setting)"


#------------------------------------------------------------------------------
# RUNTIME STATISTICS
#------------------------------------------------------------------------------

# query/index statistics collector
default["postgresql"]["track_activities"]                = "on"
default["postgresql"]["track_counts"]                    = "on"
default["postgresql"]["track_functions"]                 = "none"
default["postgresql"]["track_activity_query_size"]       = 1024
default["postgresql"]["update_process_title"]            = "on"
default["postgresql"]["stats_temp_directory"]            = 'pg_stat_tmp'

# statistics monitoring
default["postgresql"]["log_parser_stats"]                = "off"
default["postgresql"]["log_planner_stats"]               = "off"
default["postgresql"]["log_executor_stats"]              = "off"
default["postgresql"]["log_statement_stats"]             = "off"


#------------------------------------------------------------------------------
# AUTOVACUUM PARAMETERS
#------------------------------------------------------------------------------

default["postgresql"]["autovacuum"]                      = "on"
default["postgresql"]["log_autovacuum_min_duration"]     = -1
default["postgresql"]["autovacuum_max_workers"]          = 3
default["postgresql"]["autovacuum_naptime"]              = "1min"
default["postgresql"]["autovacuum_vacuum_threshold"]     = 50
default["postgresql"]["autovacuum_analyze_threshold"]    = 50
default["postgresql"]["autovacuum_vacuum_scale_factor"]  = 0.2
default["postgresql"]["autovacuum_analyze_scale_factor"] = 0.1
default["postgresql"]["autovacuum_freeze_max_age"]       = 200000000
default["postgresql"]["autovacuum_vacuum_cost_delay"]    = "20ms"
default["postgresql"]["autovacuum_vacuum_cost_limit"]    = -1


#------------------------------------------------------------------------------
# CLIENT CONNECTION DEFAULTS
#------------------------------------------------------------------------------

# statement behavior
default["postgresql"]["search_path"]                     = '"$user",public'
default["postgresql"]["default_tablespace"]              = ""
default["postgresql"]["temp_tablespaces"]                = ""
default["postgresql"]["check_function_bodies"]           = "on"
default["postgresql"]["default_transaction_isolation"]   = "read committed"
default["postgresql"]["default_transaction_read_only"]   = "off"
default["postgresql"]["default_transaction_deferrable"]  = "off"
default["postgresql"]["session_replication_role"]        = "origin"
default["postgresql"]["statement_timeout"]               = 0
default["postgresql"]["vacuum_freeze_min_age"]           = 50000000
default["postgresql"]["vacuum_freeze_table_age"]         = 150000000
default["postgresql"]["bytea_output"]                    = "hex"
default["postgresql"]["xmlbinary"]                       = "base64"
default["postgresql"]["xmloption"]                       = "content"

# locale and formatting
default["postgresql"]["datestyle"]                       = "iso, mdy"
default["postgresql"]["intervalstyle"]                   = "postgres"
default["postgresql"]["timezone"]                        = "(defaults to server environment setting)"
default["postgresql"]["timezone_abbreviations"]          = "Default"
default["postgresql"]["extra_float_digits"]              = 0
default["postgresql"]["client_encoding"]                 = "sql_ascii"

# These settings are initialized by initdb, but they can be changed.
default["postgresql"]["lc_messages"]                     = "en_US.UTF-8"
default["postgresql"]["lc_monetary"]                     = "en_US.UTF-8"
default["postgresql"]["lc_numeric"]                      = "en_US.UTF-8"
default["postgresql"]["lc_time"]                         = "en_US.UTF-8"

# default configuration for text search
default["postgresql"]["default_text_search_config"]      = "pg_catalog.english"

# other defaults
default["postgresql"]["dynamic_library_path"]            = "$libdir"
default["postgresql"]["local_preload_libraries"]         = ""


#------------------------------------------------------------------------------
# LOCK MANAGEMENT
#------------------------------------------------------------------------------

default["postgresql"]["deadlock_timeout"]                = "1s"
default["postgresql"]["max_locks_per_transaction"]       = 64
default["postgresql"]["max_pred_locks_per_transaction"]  = 64


#------------------------------------------------------------------------------
# VERSION/PLATFORM COMPATIBILITY
#------------------------------------------------------------------------------

# previous postgresql versions
default["postgresql"]["array_nulls"]                     = "on"
default["postgresql"]["backslash_quote"]                 = "safe_encoding"
default["postgresql"]["default_with_oids"]               = "off"
default["postgresql"]["escape_string_warning"]           = "on"
default["postgresql"]["lo_compat_privileges"]            = "off"
default["postgresql"]["quote_all_identifiers"]           = "off"
default["postgresql"]["sql_inheritance"]                 = "on"
default["postgresql"]["standard_conforming_strings"]     = "on"
default["postgresql"]["synchronize_seqscans"]            = "on"

# other platforms and clients
default["postgresql"]["transform_null_equals"]           = "off"


#------------------------------------------------------------------------------
# ERROR HANDLING
#------------------------------------------------------------------------------

default["postgresql"]["exit_on_error"]                   = "off"
default["postgresql"]["restart_after_crash"]             = "on"


#------------------------------------------------------------------------------
# USERS AND DATABASES
#------------------------------------------------------------------------------

default["postgresql"]["users"]                           = []
default["postgresql"]["databases"]                       = []
default["postgresql"]["extensions"]                      = []
default["postgresql"]["languages"]                       = []



#------------------------------------------------------------------------------
# CUSTOMIZED OPTIONS
#------------------------------------------------------------------------------

default["postgresql"]["custom_variable_classes"]         = ""


#------------------------------------------------------------------------------
# POSTGIS OPTIONS
#------------------------------------------------------------------------------

default["postgis"]["version"] = "2.1"
```


## TODO

* Add support for replication setup
* Add installation and configuration for the following packages:

```
postgresql-{version}-ip4r
postgresql-{version}-pgq3
postgresql-{version}-pgmp
postgresql-{version}-plproxy
postgresql-{version}-repmgr
postgresql-{version}-debversion
postgresql-{version}-pgpool2
postgresql-{version}-slony1-2
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Contributors

Many thanks go to the following who have contributed to making this cookbook even better:

* **[@flashingpumpkin](https://github.com/flashingpumpkin)**
    * recipe bugfixes
    * add `pg_user` and `pg_database` definitions
* **[@cmer](https://github.com/cmer)**
    * add `encrypted_password` param for `pg_user` definition
* **[@dickeyxxx](https://github.com/dickeyxxx)**
    * speed up recipe loading and execution
    * add support for specifying database locale
    * add support for adding users and databases via attributes
* **[@alno](https://github.com/alno)**
    * add support to install additional languages/extensions/postgis to existing databases
    * add `pg_database_extensions` definition
* **[@ermolaev](https://github.com/ermolaev)**
    * improve platform check for source repo
    * support debian 7 (wheezy)
* **[@escobera](https://github.com/escobera)**
    * fix for missing ssl directives in `postgresql.conf`
* **[@cdoughty77](https://github.com/cdoughty77)**
    * allow finer tuning inside pg_hba.conf file
* **[@NOX73](https://github.com/NOX73)**
    * fix `postgresql.conf` ssl parameter failure on 9.1
* **[@navinpeiris](https://github.com/navinpeiris)**
    * add ability to configure apt distribution
* **[@michihuber](https://github.com/michihuber)**
    * create data/config dirs recursively
* **[@sethcall](https://github.com/sethcall)**
    * allow 'lazy' evaluation of configs in the custom template
* **[@jherdman](https://github.com/jherdman)**
    * update README to include updated apt repository link
    * add support for version 9.3
* **[@stianselland](https://github.com/stianselland)**
    * fix idempotence for `pg_user` definition
* **[@alenia](https://github.com/alenia)**
    * conditionally override attributes in `postgresql.conf`
    * support for customizable apt sources
    * add ability to use an apt keyserver
* **[@Randommood](https://github.com/Randommood)**
    * conditionally override attributes in `postgresql.conf`
    * support for customizable apt sources
    * add ability to use an apt keyserver
* **[@vrischmann](https://github.com/vrischmann)**
    * uncomment `wal_writer_delay` attribute
* **[@brainopia](https://github.com/brainopia)**
    * support `encrypted_password` in the `pg_user` recipe
* **[@tpitale](https://github.com/tpitale)**
    * update example encoding/locales in README to fix error
* **[@seamusabshere](https://github.com/seamusabshere)**
    * uncomment various configuration settings
    * uncomment more configuration settings
    * uncomment `commit_delay` and `temp_buffers` settings
    * uncomment `random_page_cost` and `seq_page_cost` settings
* **[@RichardWigley](https://github.com/RichardWigley)**
    * fix empty password causes exception
* **[@phumpal](https://github.com/phumpal)**
    * update `default["postgresql"]["apt_key"]` to new location
* **[@mjallday](https://github.com/mjallday)**
    * allow controlling how to restart postgres
* **[@cgunther](https://github.com/cgunther)**
    * uncomment `log_filename` attribute
* **[@rosenfeld](https://github.com/rosenfeld)**
    * ensure proper database is selected in `pg_database` definition
* **[@j-martin](https://github.com/j-martin)**
    * ensure proper quoting of role name in `pg_user` definition
* **[@helgi](https://github.com/helgi)**
    * add replication mode to `pg_user` definition
* **[@vesln](https://github.com/vesln)**
    * add missing `ssl_ca_file` and `ssl_crl_file` attributes to the configuration template
* **[@vivid-inc](https://github.com/vivid-inc)**
    * add `service_actions` attribute
* **[@rmoriz](https://github.com/rmoriz)**
    * remove redundant postgis attribute


## License

**chef-postgresql**

* Freely distributable and licensed under the [MIT license](http://phlipper.mit-license.org/2012-2015/license.html).
* Copyright (c) 2012-2015 Phil Cohen (github@phlippers.net)
* http://phlippers.net/
