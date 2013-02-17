#
# Cookbook Name:: postgresql
# Recipe:: pg_database
#


# setup databases
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
