define :pg_database, action: :create do

  defaults    = {
    user: "postgres",
    username: nil,
    host: nil,
    port: nil,
    encoding: "utf8",
    locale: nil,
    template: nil,
    owner: nil
  }

  defaults.merge! params

  db_name = params[:name]

  db_exists = %(psql -c "SELECT datname from pg_database WHERE datname='#{db_name}'" postgres) # rubocop:disable LineLength
  db_exists << " --host #{defaults[:host]}" if defaults[:host]
  db_exists << " --port #{defaults[:port]}" if defaults[:port]
  db_exists << " | grep #{db_name}"

  case params[:action]
  when :create
    createdb_cmd = "createdb"
    createdb_cmd << " -U #{defaults[:username]}" if defaults[:username]
    createdb_cmd << " -E #{defaults[:encoding]}" if defaults[:encoding]
    createdb_cmd << " --locale #{defaults[:locale]}" if defaults[:locale]
    createdb_cmd << " -T #{defaults[:template]}" if defaults[:template]
    createdb_cmd << " --host #{defaults[:host]}" if defaults[:host]
    createdb_cmd << " --port #{defaults[:port]}" if defaults[:port]
    createdb_cmd << " -O #{defaults[:owner]}" if defaults[:owner]
    createdb_cmd << " #{db_name}"

    execute "create pg database #{db_name}" do
      user defaults[:user]
      command createdb_cmd
      not_if db_exists, user: defaults[:user]
    end

  when :drop
    dropdb_cmd = "dropdb"
    dropdb_cmd << " -U #{defaults[:username]}" if defaults[:username]
    dropdb_cmd << " --host #{defaults[:host]}" if defaults[:host]
    dropdb_cmd << " --port #{defaults[:port]}" if defaults[:port]
    dropdb_cmd << " #{db_name}"

    execute "drop pg database #{db_name}" do
      user defaults[:user]
      command dropdb_cmd
      only_if db_exists, user: defaults[:user]
    end
  end
end
