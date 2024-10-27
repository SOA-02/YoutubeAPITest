# frozen_string_literal: true

<<<<<<< HEAD
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    Outline::App.db.run('PRAGMA foreign_keys = OFF')
    Outline::Database::VideoOrm.map(&:destroy)
=======
# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    # Outline::App.db.run('PRAGMA foreign_keys = OFF')
    Outline::Database::ChannelOrm.map(&:destroy)
    puts "Outline::Database: #{Outline::Database.inspect}" if defined?(Outline::Database)

>>>>>>> main
    Outline::App.db.run('PRAGMA foreign_keys = ON')
  end
end
