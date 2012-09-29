define :pg_database_extensions, :action => :create do

  dbname = params[:name]
  languages = [params[:languages] || []].flatten # Allow single value or array of values
  extensions = [params[:extensions] || []].flatten
  postgis = params[:postgis]

  postgresql_version = node["postgresql"]["version"]
  postgis_version = node["postgis"]["version"]

  case params[:action]
  when :create

    languages.each do |language|
      execute "createlang #{language} #{dbname}" do
        user "postgres"
        not_if "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{dbname} | grep '^ #{language}$'", :user => "postgres"
      end
    end

    extensions.each do |extension|
      execute "psql -c 'CREATE EXTENSION IF NOT EXISTS #{extension}' #{dbname}" do
        user "postgres"
      end
    end

    if postgis
      include_recipe 'postgresql::postgis'

      execute "psql -d #{dbname} -f /usr/share/postgresql/#{postgresql_version}/contrib/postgis-#{postgis_version}/postgis.sql" do
        user "postgres"
        not_if "psql -c \"SELECT proname FROM pg_catalog.pg_proc WHERE proname = 'st_area'\" #{dbname} | grep 'st_area$'", :user => "postgres"
      end

      execute "psql -d #{dbname} -f /usr/share/postgresql/#{postgresql_version}/contrib/postgis-#{postgis_version}/spatial_ref_sys.sql" do
        user "postgres"
        only_if "psql -c 'SELECT count(1) FROM spatial_ref_sys' #{dbname} | grep '0$'", :user => "postgres"
      end

      [:geometry_columns, :geography_columns, :spatial_ref_sys].each do |table|
        execute "psql -c 'GRANT ALL ON #{table} TO PUBLIC' #{dbname}" do
          user "postgres"
        end
      end
    end

  when :drop

    languages.each do |language|
      execute "droplang #{language} #{dbname}" do
        user "postgres"
        only_if "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{dbname} | grep '^ #{language}$'", :user => "postgres"
      end
    end

    extensions.each do |extension|
      execute "psql -c 'DROP EXTENSION IF EXISTS #{extension}' #{dbname}" do
        user "postgres"
      end
    end

    if postgis
      Chef::Log.warn("Postgis support dropping isn't supported")
    end

  end
end
