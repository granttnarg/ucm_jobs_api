class AddSearchIndexes < ActiveRecord::Migration[8.0]
    def up
      # Enable pg_trgm extension for better text search
      execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"

      # Add GIN index on job titles for faster ILIKE queries
      add_index :jobs, :title, using: :gin, opclass: { title: :gin_trgm_ops }

      add_index :languages, :code
    end

    def down
      remove_index :jobs, :title
      remove_index :languages, :code

      execute "DROP EXTENSION IF EXISTS pg_trgm;"
    end
end
