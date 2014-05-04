define :pg_user, action: :create do
  role_name = params[:name]

  case params[:action]
  when :create
    privileges = {
      superuser: false,
      createdb: false,
      login: true
    }
    privileges.merge! params[:privileges] if params[:privileges]

    role_sql = "#{role_name} "

    role_sql << Array(privileges).map! { |priv, bool| (bool ? "" : "NO") + priv.to_s.upcase }.join(" ") # rubocop:disable LineLength

    role_sql << if params[:encrypted_password]
                  " ENCRYPTED PASSWORD '#{params[:encrypted_password]}'"
                elsif params[:password]
                  " PASSWORD '#{params[:password]}'"
                else
                  ""
                end

    role_exists = %(psql -c "SELECT rolname FROM pg_roles WHERE rolname='#{role_name}'" | grep #{role_name}) # rubocop:disable LineLength

    execute "alter pg user #{role_name}" do
      user "postgres"
      command %(psql -c "ALTER ROLE #{role_sql}")
      only_if role_exists, user: "postgres"
    end

    execute "create pg user #{role_name}" do
      user "postgres"
      command %(psql -c "CREATE ROLE #{role_sql}")
      not_if role_exists, user: "postgres"
    end

  when :drop
    execute "drop pg user #{role_name}" do
      user "postgres"
      command %(psql -c "DROP ROLE IF EXISTS #{role_name}")
    end
  end
end
