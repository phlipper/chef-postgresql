require_relative "test_helper"

describe_recipe "postgresql::libpq" do
  it "installed the `libpq5` package" do
    package("libpq5").must_be_installed
  end

  it "installed the `libpq-dev` package" do
    package("libpq-dev").must_be_installed
  end
end
