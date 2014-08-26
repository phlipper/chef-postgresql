#
# Cookbook Name:: postgresql
# Recipe:: setup_languages
#

# setup database languages
node["postgresql"]["languages"].each do |lang|
  lang_action = (lang["action"] || "create").to_sym

  postgresql_language lang["name"] do
    database lang["database"]
    action lang_action
  end
end
