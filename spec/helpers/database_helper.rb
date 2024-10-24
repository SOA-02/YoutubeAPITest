# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    # Outline::App.db.run('PRAGMA foreign_keys = OFF')
    Outline::Database::ChannelOrm.map(&:destroy)
    puts "Outline::Database: #{Outline::Database.inspect}" if defined?(Outline::Database)

    Outline::App.db.run('PRAGMA foreign_keys = ON')
  end
end
