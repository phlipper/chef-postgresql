#
# Cookbook Name:: postgresql
# Recipe:: server
#

require_recipe "postgresql"

pg_version = node["postgresql"]["version"]

# install the package
package "postgresql-#{pg_version}"


# environment
template "/etc/postgresql/#{pg_version}/main/environment" do
  source "environment.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]"
end

# pg_ctl
template "/etc/postgresql/#{pg_version}/main/pg_ctl.conf" do
  source "pg_ctl.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]"
end

# pg_hba
template node["postgresql"]["hba_file"] do
  source "pg_hba.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0640"
  notifies :restart, "service[postgresql]"
end

# pg_ident
template node["postgresql"]["ident_file"] do
  source "pg_ident.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0640"
  notifies :restart, "service[postgresql]"
end

# postgresql
template "/etc/postgresql/#{pg_version}/main/postgresql.conf" do
  source "postgresql.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]"
end

# start
template "/etc/postgresql/#{pg_version}/main/start.conf" do
  source "start.conf.erb"
  owner  "postgres"
  group  "postgres"
  mode   "0644"
  notifies :restart, "service[postgresql]", :immediately
end

node["postgresql"]["users"].each do |user|
  pg_user user["username"] do
    privileges :superuser => user["superuser"], :createdb => user["createdb"], :login => user["login"]
    password user["password"]
  end
end

node["postgresql"]["databases"].each do |database|
  pg_database database["name"] do
    owner database["owner"]
    encoding database["encoding"]
    template database["template"]
    locale database["locale"]
  end

  pg_database_extensions database["name"] do
    extensions database["extensions"]
    languages database["languages"]
    postgis database["postgis"]
  end
end

# define the service
service "postgresql" do
  supports :restart => true
  action [:enable, :start]
end
