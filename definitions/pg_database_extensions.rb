define :pg_database_extensions, action: :create do

  dbname = params[:name]
  languages = Array(params[:languages]) # Allow single value or array of values
  extensions = Array(params[:extensions])
  postgis = params[:postgis]

  case params[:action]
  when :create

    languages.each do |language|
      execute "createlang #{language} #{dbname}" do
        user "postgres"
        not_if "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{dbname} | grep '^ #{language}$'", user: "postgres"
      end
    end

    extensions.each do |extension|
      execute "psql -c 'CREATE EXTENSION IF NOT EXISTS #{extension}' #{dbname}" do
        user "postgres"
      end
    end

    if postgis
      include_recipe "postgresql::postgis"

      %w[postgis postgis_topology].each do |ext|
        execute "psql -c 'CREATE EXTENSION IF NOT EXISTS #{ext}' #{dbname}" do
          user "postgres"
        end
      end
    end

  when :drop

    languages.each do |language|
      execute "droplang #{language} #{dbname}" do
        user "postgres"
        only_if "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{dbname} | grep '^ #{language}$'", user: "postgres"
      end
    end

    extensions.each do |extension|
      execute "psql -c 'DROP EXTENSION IF EXISTS #{extension}' #{dbname}" do
        user "postgres"
      end
    end

    if postgis
      %w[postgis postgis_topology].each do |ext|
        execute "psql -c 'DROP EXTENSION IF EXISTS #{ext}' #{dbname}" do
          user "postgres"
        end
      end
    end

  end
end
