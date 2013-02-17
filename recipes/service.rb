#
# Cookbook Name:: postgresql
# Recipe:: service
#


# define the service
service "postgresql" do
  supports :restart => true
  action [:enable, :start]
end
