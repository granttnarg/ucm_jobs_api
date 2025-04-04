class AddCompanyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :company, foreign_key: true # only admin users are linked to companies
  end
end
