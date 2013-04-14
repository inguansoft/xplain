class CreateStateLogs < ActiveRecord::Migration
  def change
    Cata.schema_based_on_model self, StateLog
  end
end
