#
# Cookbook Name:: postgresql
# Recipe:: pg_user
#


# setup users
node["postgresql"]["users"].each do |user|
  pg_user user["username"] do
    privileges superuser: user["superuser"], createdb: user["createdb"], login: user["login"]
    password user["password"]
  end
end
