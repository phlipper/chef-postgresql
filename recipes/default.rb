#
# Cookbook Name:: postgresql
# Recipe:: default
#

package "python-software-properties"

execute "setup ppa apt repository" do
  command "add-apt-repository ppa:pitti/postgresql && apt-get update"
  not_if  "test -f /etc/apt/sources.list.d/pitti-postgresql-#{node["lsb"]["codename"]}.list"
end

package "postgresql-common"
