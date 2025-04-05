class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.decimal :hourly_salary, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
