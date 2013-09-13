#
# Cookbook Name:: postgresql
# Recipe:: data_directory
#


# ensure data directory exists
directory node["postgresql"]["data_directory"] do
  owner  "postgres"
  group  "postgres"
  mode   "0700"
  recursive true
  not_if "test -f #{node["postgresql"]["data_directory"]}/PG_VERSION"
end

# initialize the data directory if necessary
bash "postgresql initdb" do
  user "postgres"
  code <<-EOC
  /usr/lib/postgresql/#{node["postgresql"]["version"]}/bin/initdb \
    #{node["postgresql"]["initdb_options"]} \
    -U postgres \
    -D #{node["postgresql"]["data_directory"]}
  EOC
  not_if "test -f #{node["postgresql"]["data_directory"]}/PG_VERSION"
end
