#
# Cookbook Name:: postgresql
# Provider:: language
#

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  unless @current_resource.exists
    converge_by "Create PostgreSQL Language #{new_resource.name}" do
      if language_package_needed?
        package "postgresql-contrib-#{pg_version}"
        package language_package_map[new_resource.name]
      end

      execute "createlang #{language_name} #{new_resource.database}" do
        user "postgres"
      end

      new_resource.updated_by_last_action(true)
    end
  end
end

action :drop do
  if @current_resource.exists
    converge_by "Drop PostgreSQL Language #{new_resource.name}" do
      execute "droplang #{language_name} #{new_resource.database}" do
        user "postgres"
      end

      if language_package_needed?  # ~FC023 - scope
        package language_package_map[new_resource.name] do
          action :purge
        end
      end

      new_resource.updated_by_last_action(true)
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::PostgresqlLanguage.new(new_resource.name)
  @current_resource.name(new_resource.name)

  @current_resource.exists = language_exists?
end

def language_exists?
  exists = %(psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{new_resource.database} | grep '^ #{language_name}$') # rubocop:disable LineLength

  cmd = Mixlib::ShellOut.new(exists, user: "postgres")
  cmd.run_command
  cmd.exitstatus.zero?
end

def language_name
  control_file_name_for_language(new_resource.name)
end

def language_package_needed?
  language_package_map.keys.include?(new_resource.name)
end

def control_file_name_for_language(language)
  control_file_map = {
    "plpython" => "plpythonu",
    "plpython3" => "plpython3u"
  }

  # fetch the name or passthrough the key
  control_file_map.fetch(language) { |key| key }
end

def language_package_map  # rubocop:disable Metrics/MethodLength
  {
    "pllua" => "postgresql-#{pg_version}-pllua",
    "plperl" => "postgresql-plperl-#{pg_version}",
    "plproxy" => "postgresql-#{pg_version}-plproxy",
    "plpython" => "postgresql-plpython-#{pg_version}",
    "plpython3" => "postgresql-plpython3-#{pg_version}",
    "plr" => "postgresql-#{pg_version}-plr",
    "plsh" => "postgresql-#{pg_version}-plsh",
    "pltcl" => "postgresql-pltcl-#{pg_version}",
    "plv8" => "postgresql-#{pg_version}-plv8"
  }
end

def pg_version
  new_resource.db_version
end
