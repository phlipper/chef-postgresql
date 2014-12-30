require "spec_helper"

describe "postgresql::configuration" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["postgresql"]["version"] = "9.3"
      node.set["postgresql"]["conf"] = { "foo" => "bar" }
    end.converge("recipe[postgresql::service]", described_recipe)
  end

  let(:template_paths) do
    {
      "environment" => "/etc/postgresql/9.3/main/environment",
      "pg_ctl.conf" => "/etc/postgresql/9.3/main/pg_ctl.conf",
      "pg_hba.conf" => "/etc/postgresql/9.3/main/pg_hba.conf",
      "pg_ident.conf" => "/etc/postgresql/9.3/main/pg_ident.conf",
      "postgresql.conf" => "/etc/postgresql/9.3/main/postgresql.conf",
      "start.conf" => "/etc/postgresql/9.3/main/start.conf"
    }
  end

  it "creates the `main` configuration directory" do
    expect(chef_run).to create_directory("/etc/postgresql/9.3/main/").with(
      user: "postgres",
      group: "postgres",
      recursive: true
    )
  end

  it "creates the `environment` file" do
    env_template = template_paths["environment"]

    expect(chef_run).to create_template(env_template).with(
      source: "environment.erb",
      owner:  "postgres",
      group:  "postgres",
      mode:   "0644"
    )
    expect(chef_run.template(env_template)).to(
      notify("service[postgresql]").to(:restart)
    )
  end

  it "creates the `pg_ctl.conf` file" do
    pg_ctl_template = template_paths["pg_ctl.conf"]

    expect(chef_run).to create_template(pg_ctl_template).with(
      source: "pg_ctl.conf.erb",
      owner:  "postgres",
      group:  "postgres",
      mode:   "0644"
    )
    expect(chef_run.template(pg_ctl_template)).to(
      notify("service[postgresql]").to(:restart)
    )
  end

  it "creates the `pg_hba.conf` file" do
    pg_hba_template = template_paths["pg_hba.conf"]

    expect(chef_run).to create_template(pg_hba_template).with(
      source: "pg_hba.conf.erb",
      owner:  "postgres",
      group:  "postgres",
      mode:   "0640"
    )
    expect(chef_run.template(pg_hba_template)).to(
      notify("service[postgresql]").to(:reload)
    )
  end

  it "creates the `pg_ident.conf` file" do
    pg_ident_template = template_paths["pg_ident.conf"]

    expect(chef_run).to create_template(pg_ident_template).with(
      source: "pg_ident.conf.erb",
      owner:  "postgres",
      group:  "postgres",
      mode:   "0640"
    )
    expect(chef_run.template(pg_ident_template)).to(
      notify("service[postgresql]").to(:reload)
    )
  end

  context "`postgresql.conf` file" do
    context "using the `standard` template" do
      it "creates the file" do
        postgresql_template = template_paths["postgresql.conf"]

        expect(chef_run).to create_template(postgresql_template).with(
          source: "postgresql.conf.erb",
          owner:  "postgres",
          group:  "postgres",
          mode:   "0644"
        )

        expect(chef_run).to(
          render_file(postgresql_template).with_content(
            /^# PostgreSQL configuration file/
          )
        )

        expect(chef_run).to(
          render_file(postgresql_template).with_content(/foo = 'bar'/)
        )

        expect(chef_run.template(postgresql_template)).to(
          notify("service[postgresql]").to(:restart)
        )
      end

      context "using the `conf_custom` attribute" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new do |node|
            node.set["postgresql"]["version"] = "9.3"
            node.set["postgresql"]["conf"] = { "foo" => "bar" }
            node.set["postgresql"]["conf_custom"] = true
          end.converge("recipe[postgresql::service]", described_recipe)
        end

        it "creates the file" do
          postgresql_template = template_paths["postgresql.conf"]

          expect(chef_run).to create_file(postgresql_template).with(
            owner:  "postgres",
            group:  "postgres",
            mode:   "0644"
          )

          expect(chef_run).to_not(
            render_file(postgresql_template).with_content(
              /^# PostgreSQL configuration file/
            )
          )

          expect(chef_run).to(
            render_file(postgresql_template).with_content("foo = 'bar'")
          )

          expect(chef_run.file(postgresql_template)).to(
            notify("service[postgresql]").to(:restart)
          )
        end
      end
    end
  end

  it "creates the `start.conf` template" do
    start_template = template_paths["start.conf"]

    expect(chef_run).to create_template(start_template).with(
      source: "start.conf.erb",
      owner:  "postgres",
      group:  "postgres",
      mode:   "0644"
    )

    expect(chef_run.template(start_template)).to(
      notify("service[postgresql]").to(:restart).immediately
    )
  end
end
