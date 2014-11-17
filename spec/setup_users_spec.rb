require "spec_helper"

describe "postgresql::setup_users" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ["postgresql_user"]) do |node|
      node.set["postgresql"]["users"] = [
        { username: "test1", password: nil, createdb: true },
        { username: "test2", password: "foo", action: %w[create update] },
        { username: "test3", action: :drop }
      ]
    end.converge(described_recipe)
  end

  before do
    allow(Mixlib::ShellOut).to receive_messages(
      new: double(run_command: nil, exitstatus: 1)
    )
  end

  specify do
    expect(chef_run).to create_postgresql_user("test1").with(createdb: true)

    expect(chef_run).to create_postgresql_user("test2").with(password: "foo")
    expect(chef_run).to update_postgresql_user("test2").with(password: "foo")

    expect(chef_run).to drop_postgresql_user("test3")
  end
end
