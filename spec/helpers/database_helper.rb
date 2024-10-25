# frozen_string_literal: true

module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    # Outline::App.db.run('PRAGMA foreign_keys = OFF')
    # Outline::Database::VideoOrm.map(&:destroy)
    # Outline::App.db.run('PRAGMA foreign_keys = ON')
  end
end
