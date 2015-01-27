#
# Cookbook Name:: postgresql
# Provider:: extension
#

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  unless @current_resource.exists
    converge_by "Create PostgreSQL Extension #{extension_name}" do
      package "postgresql-contrib-#{new_resource.db_version}"

      sql = "CREATE EXTENSION IF NOT EXISTS #{extension_name}"

      execute "create #{extension_name} extension" do
        command %(psql -c '#{sql}' #{new_resource.database})
        user "postgres"
      end

      new_resource.updated_by_last_action(true)
    end
  end
end

action :drop do
  if @current_resource.exists
    converge_by "Drop PostgreSQL Extension #{extension_name}" do
      sql = "DROP EXTENSION IF EXISTS #{extension_name}"

      execute "drop #{extension_name} extension" do
        command %(psql -c '#{sql}' #{new_resource.database})
        user "postgres"
      end

      new_resource.updated_by_last_action(true)
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::PostgresqlExtension.new(new_resource.name)
  @current_resource.name(new_resource.name)

  @current_resource.exists = extension_exists?
end

def extension_name
  name = new_resource.name
  name.match("-") ? %("#{name}") : name
end

def extension_exists?
  exists = %(psql -c "\\dx" #{new_resource.database} | grep #{extension_name})

  cmd = Mixlib::ShellOut.new(exists, user: "postgres")
  cmd.run_command
  cmd.exitstatus.zero?
end
