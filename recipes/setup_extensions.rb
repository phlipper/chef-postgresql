#
# Cookbook Name:: postgresql
# Recipe:: setup_extensions
#

include_recipe "postgresql::contrib"

# setup database extensions
node["postgresql"]["extensions"].each do |ext|
  ext_action = (ext["action"] || "create").to_sym

  postgresql_extension ext["name"] do
    database ext["database"]
    action ext_action
  end
end
