#
# Cookbook Name:: postgresql
# Recipe:: pg_database
#

databases = Array(node["postgresql"]["databases"])
extensions = databases.map { |db| db["extensions"] }.flatten.compact

# include `contrib` recipe if there are any extensions to install
include_recipe "postgresql::contrib" if extensions.any?

# setup databases
databases.each do |db|
  postgresql_database db["name"] do
    owner db["owner"]
    encoding db["encoding"]
    template db["template"]
    locale db["locale"]
  end

  Array(db["extensions"]).each do |extension|
    postgresql_extension extension do
      database db["name"]
    end
  end

  if db["postgis"]
    %w[postgis postgis_topology].each do |extension|
      postgresql_extension extension do
        database db["name"]
      end
    end
  end

  Array(db["languages"]).each do |language|
    postgresql_language language do
      database db["name"]
    end
  end
end
