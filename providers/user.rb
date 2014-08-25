#
# Cookbook Name:: postgresql
# Provider:: user
#

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  unless @current_resource.exists
    converge_by "Create PostgreSQL User #{new_resource.name}" do
      execute "create postgresql user #{new_resource.name}" do
        user "postgres"
        command %(psql -c "CREATE ROLE #{role_sql}")
      end

      new_resource.updated_by_last_action(true)
    end
  end
end

action :update do
  if @current_resource.exists
    converge_by "Update PostgreSQL User #{new_resource.name}" do
      execute "update postgresql user #{new_resource.name}" do
        user "postgres"
        command %(psql -c "ALTER ROLE #{role_sql}")
      end

      new_resource.updated_by_last_action(true)
    end
  end
end

action :drop do
  if @current_resource.exists
    converge_by "Drop PostgreSQL User #{new_resource.name}" do
      execute "drop postgresql user #{new_resource.name}" do
        user "postgres"
        command %(psql -c 'DROP ROLE IF EXISTS \\\"#{new_resource.name}\\\"')
      end

      new_resource.updated_by_last_action(true)
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::PostgresqlUser.new(new_resource.name)
  @current_resource.name(new_resource.name)

  @current_resource.exists = user_exists?
end

def user_exists?
  exists = %(psql -c "SELECT rolname FROM pg_roles WHERE rolname='#{new_resource.name}'" | grep '#{new_resource.name}') # rubocop:disable LineLength

  cmd = Mixlib::ShellOut.new(exists, user: "postgres")
  cmd.run_command
  cmd.exitstatus.zero?
end

def role_sql # rubocop:disable MethodLength
  sql = %(\\\"#{new_resource.name}\\\" )

  sql << "#{"NO" unless new_resource.superuser}SUPERUSER "
  sql << "#{"NO" unless new_resource.createdb}CREATEDB "
  sql << "#{"NO" unless new_resource.login}LOGIN "

  sql << if new_resource.encrypted_password
           "ENCRYPTED PASSWORD '#{new_resource.encrypted_password}'"
         elsif new_resource.password
           "PASSWORD '#{new_resource.password}'"
         else
           ""
         end
end
