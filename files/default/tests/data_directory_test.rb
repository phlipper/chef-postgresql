require_relative "test_helper"

describe_recipe "postgresql::data_directory" do
  it "created the 'data directory'" do
    directory(node["postgresql"]["data_directory"]).must_exist
      .with(:owner, "postgres").and(:group, "postgres").and(:mode, "0700")

    file("#{node["postgresql"]["data_directory"]}/PG_VERSION").must_exist
  end
end
