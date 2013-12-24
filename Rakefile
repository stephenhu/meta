require "bundler/gem_tasks"
require "sequel"
require "sqlite3"

DB = "db/site.sqlite3".freeze

Sequel.extension :migration, :core_extensions

task :default => :help

namespace :db do

  desc "instantiate database"
  task :create do

    SQLite3::Database.new(DB)

  end

  desc "migrate database"
  task :migrate do

    # sequel -m db/migrate sqlite://site.sqlite3
    conn = Sequel.sqlite(DB)
    Sequel::Migrator.run( conn, "db/migrate" )

  end

end

desc "help"
task :help do

  puts "rake"
  puts "  db:create"
  puts "  db:migrate"

end

