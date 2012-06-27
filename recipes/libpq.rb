#
# Cookbook Name:: postgresql
# Recipe:: libpq
#

require_recipe "postgresql"

package "libpq5"
package "libpq-dev"
