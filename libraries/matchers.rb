if defined?(ChefSpec)
  def create_postgresql_database(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_database, :create, resource_name
    )
  end

  def drop_postgresql_database(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_database, :drop, resource_name
    )
  end

  def create_postgresql_extension(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_extension, :create, resource_name
    )
  end

  def drop_postgresql_extension(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_extension, :drop, resource_name
    )
  end

  def create_postgresql_language(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_language, :create, resource_name
    )
  end

  def drop_postgresql_language(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_language, :drop, resource_name
    )
  end

  def create_postgresql_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_user, :create, resource_name
    )
  end

  def update_postgresql_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_user, :update, resource_name
    )
  end

  def drop_postgresql_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postgresql_user, :drop, resource_name
    )
  end
end
