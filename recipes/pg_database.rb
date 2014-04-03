#
# Cookbook Name:: postgresql
# Recipe:: pg_database
#

databases = Array(node["postgresql"]["databases"])
extensions = databases.map { |db| db["extensions"] }.flatten.compact

# include `contrib` recipe if there are any extensions to install
include_recipe "postgresql::contrib" if extensions.any?

# setup databases
databases.each do |database|
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
