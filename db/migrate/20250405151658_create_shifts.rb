class CreateShifts < ActiveRecord::Migration[8.0]
  def change
    create_table :shifts do |t|
      t.references :job, null: false, foreign_key: true
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime, null: false

      t.timestamps
    end

    add_index :shifts, [ :job_id, :start_datetime ]
  end
end
