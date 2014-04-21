define :pg_database_extensions, action: :create do  # ~FC022

  dbname = params[:name]
  languages = Array(params[:languages]) # Allow single value or array of values
  extensions = Array(params[:extensions])
  postgis = params[:postgis]

  case params[:action]
  when :create

    languages.each do |language|
      execute "createlang #{language} #{dbname}" do
        user "postgres"
        not_if "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{dbname} | grep '^ #{language}$'", user: "postgres" # rubocop:disable LineLength
      end
    end

    extensions.each do |extension|
      # quote extension with dashes, like `uuid-ossp`
      extension = %("#{extension}") if extension.match("-")

      execute "create #{extension} extension" do
        command %(psql -c 'CREATE EXTENSION IF NOT EXISTS #{extension}' #{dbname}) # rubocop:disable LineLength
        user "postgres"
      end
    end

    if postgis
      include_recipe "postgresql::postgis"

      %w[postgis postgis_topology].each do |ext|
        execute "create #{ext} extension" do
          command %(psql -c "CREATE EXTENSION IF NOT EXISTS #{ext}" #{dbname})
          user "postgres"
        end
      end
    end

  when :drop

    languages.each do |language|
      execute "droplang #{language} #{dbname}" do
        user "postgres"
        only_if "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{dbname} | grep '^ #{language}$'", user: "postgres" # rubocop:disable LineLength
      end
    end

    extensions.each do |extension|
      # quote extension with dashes, like `uuid-ossp`
      extension = %("#{extension}") if extension.match("-")

      execute "drop #{extension} extension" do
        command %(psql -c 'DROP EXTENSION IF EXISTS #{extension}' #{dbname})
        user "postgres"
      end
    end

    if postgis
      %w[postgis postgis_topology].each do |ext|
        execute "drop #{ext} extension" do
          command %(psql -c "DROP EXTENSION IF EXISTS #{ext}" #{dbname})
          user "postgres"
        end
      end
    end

  end
end
