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
      execute "createlang #{new_resource.name} #{new_resource.database}" do
        user "postgres"
      end

      new_resource.updated_by_last_action(true)
    end
  end
end

action :drop do
  if @current_resource.exists
    converge_by "Drop PostgreSQL Language #{new_resource.name}" do
      execute "droplang #{new_resource.name} #{new_resource.database}" do
        user "postgres"
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
  exists = %(psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{new_resource.database} | grep '^ #{new_resource.name}$') # rubocop:disable LineLength

  cmd = Mixlib::ShellOut.new(exists, user: "postgres")
  cmd.run_command
  cmd.exitstatus.zero?
end
