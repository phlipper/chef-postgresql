require "spec_helper"

describe "postgresql_user" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ["postgresql_user"]) do |node|
      node.set["postgresql"]["users"] = [
        { username: "test1", password: nil, createdb: true },
        { username: "test2", password: "foo", action: %w[create update] },
        { username: "test3", action: :drop }
      ]
    end.converge("postgresql::setup_users")
  end

  describe "create" do
    before do
      allow(Mixlib::ShellOut).to receive_messages(
        new: double(run_command: nil, exitstatus: 1)
      )
    end

    specify do
      expect(chef_run).to run_execute("create postgresql user test1").with(
        user: "postgres"
      )

      expect(chef_run).to run_execute("create postgresql user test2").with(
        user: "postgres"
      )
    end
  end

  describe "update and drop" do
    before do
      allow(Mixlib::ShellOut).to receive_messages(
        new: double(run_command: nil, exitstatus: 0)
      )
    end

    specify do
      expect(chef_run).to run_execute("update postgresql user test2").with(
        user: "postgres"
      )

      expect(chef_run).to run_execute("drop postgresql user test3").with(
        user: "postgres"
      )
    end
  end
end
