class CreateStatuses < ActiveRecord::Migration
  def change
    Cata.schema_based_on_model self, Status
  end
end
