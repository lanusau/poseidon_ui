# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
TargetType.create(
  {
    :name => 'Oracle',
    :url_ruby => 'dbi:oci8:(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=%h)(PORT=%p))(CONNECT_DATA=(SERVICE_NAME=%d)))',
    :url_jdbc => 'jdbc:oracle:thin:@//%h:%p/%d',
    :create_sysdate => DateTime.now(),
    :update_sysdate => DateTime.now()
  }, :without_protection => true)
TargetType.create(
  {
    :name => 'MySQL',
    :url_ruby => 'dbi:mysql:database=%d;host=%h;port=%p',
    :url_jdbc => 'jdbc:mysql://%h:%p/%d',
    :create_sysdate => DateTime.now(),
    :update_sysdate => DateTime.now()
  }, :without_protection => true)
TargetType.create(
  {
    :name => 'Postgres',
    :url_ruby => 'dbi:Pg:dbname=%d;host=%h;port=%p',
    :url_jdbc => 'jdbc:postgresql://%h:%p/%d',
    :create_sysdate => DateTime.now(),
    :update_sysdate => DateTime.now()
  }, :without_protection => true)