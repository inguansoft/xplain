class CreateUsers < ActiveRecord::Migration
  def change
    Cata.schema_based_on_model self, User

    create_table :state_logs_users, :id => false do |t|
      t.column :user_id, :integer
      t.column :state_log_id, :integer
    end

  end
end
