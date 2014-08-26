#
# Cookbook Name:: postgresql
# Recipe:: setup_databases
#

# setup databases
node["postgresql"]["databases"].each do |db|
  db_action = (db["action"] || "create").to_sym

  postgresql_database db["name"] do
    owner db["owner"]
    encoding db["encoding"]
    template db["template"]
    locale db["locale"]
    action db_action
  end
end
