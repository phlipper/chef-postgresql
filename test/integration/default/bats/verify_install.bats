control_script="sudo /etc/init.d/postgresql"

setup() {
  $control_script stop || true
  $control_script start
}

teardown() {
  $control_script stop || true
}

@test "postgresql.conf file must exist" {
  test -f /etc/postgresql/*/main/postgresql.conf
}

@test "pg_hba.conf file must exist" {
  test -f /etc/postgresql/*/main/pg_hba.conf
}

@test "postgres must reload cleanly" {
  $control_script reload
}
