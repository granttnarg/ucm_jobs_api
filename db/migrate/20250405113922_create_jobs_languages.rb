class CreateJobsLanguages < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs_languages do |t|
      t.references :job, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true

      t.timestamps
    end
    add_index :jobs_languages, [ :job_id, :language_id ], unique: true
  end
end
