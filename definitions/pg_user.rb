define :pg_user, action: :create do
  case params[:action]
  when :create
    privileges = {
      superuser: false,
      createdb: false,
      login: true
    }
    privileges.merge! params[:privileges] if params[:privileges]

    sql = [params[:name]]

    sql.push privileges.to_a.map!{ |p,b| (b ? "" : "NO") + p.to_s.upcase }.join(" ")

    if params[:encrypted_password]
      sql.push "ENCRYPTED PASSWORD '#{params[:encrypted_password]}'"
    elsif params[:password]
      sql.push "PASSWORD '#{params[:password]}'"
    end

    sql = sql.join(" ")

    exists = [%(psql -c "SELECT usename FROM pg_user WHERE usename='#{params[:name]}'")]
    exists.push "| grep #{params[:name]}"
    exists = exists.join ' '

    execute "altering pg user #{params[:name]}" do
      user "postgres"
      command %(psql -c "ALTER ROLE #{sql}")
      only_if exists, user: "postgres"
    end

    execute "creating pg user #{params[:name]}" do
      user "postgres"
      command %(psql -c "CREATE ROLE #{sql}")
      not_if exists, user: "postgres"
    end

  when :drop
    execute "dropping pg user #{params[:name]}" do
      user "postgres"
      command %(psql -c "DROP ROLE IF EXISTS #{params[:name]}")
    end
  end
end
