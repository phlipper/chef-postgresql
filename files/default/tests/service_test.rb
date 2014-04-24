require_relative "test_helper"

describe_recipe "postgresql::service" do
  it "enabled the `postgresql` service" do
    service("postgresql").must_be_enabled
  end

  it "started the `postgresql` service" do
    service("postgresql").must_be_running
  end
end
