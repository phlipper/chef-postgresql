define :pg_database, action: :create do

  defaults    = {
    user: "postgres",
    username: nil,
    host: nil,
    port: nil,
    encoding: "utf8",
    locale: nil,
    template: nil,
    owner: nil,
  }
  
  defaults.merge! params

  exists = ["psql"]
  exists.push %(-c "SELECT datname from pg_database WHERE datname='#{params[:name]}'")
  exists.push "--host #{defaults[:host]}" if defaults[:host]
  exists.push "--port #{defaults[:port]}" if defaults[:port]
  exists.push "| grep #{params[:name]}"

  exists = exists.join ' '

  case params[:action]
  when :create
    createdb = ["createdb"]
    createdb.push "-U #{defaults[:username]}" if defaults[:username]
    createdb.push "-E #{defaults[:encoding]}" if defaults[:encoding]
    createdb.push "--locale #{defaults[:locale]}" if defaults[:locale]
    createdb.push "-T #{defaults[:template]}" if defaults[:template]
    createdb.push "--host #{defaults[:host]}" if defaults[:host]
    createdb.push "--port #{defaults[:port]}" if defaults[:port]
    createdb.push "-O #{defaults[:owner]}" if defaults[:owner]

    createdb.push params[:name]

    createdb = createdb.join(" ")

    execute "creating pg database #{params[:name]}" do
      user defaults[:user]
      command createdb
      not_if exists, user: defaults[:user]
    end

  when :drop
    dropdb = ["dropdb"]
    dropdb.push "-U #{defaults[:username]}" if defaults[:username]
    dropdb.push "--host #{defaults[:host]}" if defaults[:host]
    dropdb.push "--port #{defaults[:port]}" if defaults[:port]

    dropdb.push params[:name]

    dropdb = dropdb.join(" ")

    execute "dropping pg database #{params[:name]}" do
      user defaults[:user]
      command dropdb
      only_if exists, user: defaults[:user]
    end
  end
end
