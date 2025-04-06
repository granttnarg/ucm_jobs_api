class RenameShiftTimeColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :shifts, :start_datetime, :start_datetime
    rename_column :shifts, :end_datetime, :end_datetime
  end
end
