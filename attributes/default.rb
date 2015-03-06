#
# Cookbook Name:: postgresql
# Attributes:: default
#
# Author:: Phil Cohen <github@phlippers.net>
#
# Copyright 2012-2013, Phil Cohen
#

default["postgresql"]["version"]                         = "9.4"

#----------------------------------------------------------------------------
# DAEMON CONTROL
#----------------------------------------------------------------------------

default["postgresql"]["service_actions"]                 = %w[enable start]
default["postgresql"]["cfg_update_action"]               = :restart

#------------------------------------------------------------------------------
# APT REPOSITORY
#------------------------------------------------------------------------------

default["postgresql"]["apt_distribution"] = node["lsb"]["codename"]
default["postgresql"]["apt_repository"]   = "apt.postgresql.org"
default["postgresql"]["apt_uri"]          = "http://apt.postgresql.org/pub/repos/apt"
default["postgresql"]["apt_components"]   = ["main", node["postgresql"]["version"]]
default["postgresql"]["apt_key"]          = "https://www.postgresql.org/media/keys/ACCC4CF8.asc"

default["postgresql"]["environment_variables"]           = {}
default["postgresql"]["pg_ctl_options"]                  = ""
default["postgresql"]["pg_hba"]                          = []
default["postgresql"]["pg_hba_defaults"]                 = true
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
default["postgresql"]["stats_temp_directory"]            = "pg_stat_tmp"

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
default["postgresql"]["autovacuum_freeze_max_age"]       = 200_000_000
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
default["postgresql"]["vacuum_freeze_min_age"]           = 50_000_000
default["postgresql"]["vacuum_freeze_table_age"]         = 150_000_000
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
