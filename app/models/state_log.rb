class StateLog < Cata

  SYSTEM_NAME = 'StateLog'
  TABLE_NAME = 'state_logs'
  ENTITY_NAME = 'state_log'
  READABLE_NAME = 'Logs'
  DB_DESCRIPTION = 'Keep log of all status transitions from all the system'

  belongs_to :status
  belongs_to :user

  FIELDS = {
      :id => [DB__INTEGER],
      :status_id => [DB__INTEGER],
      :user_id => [DB__INTEGER],
      :description => [DB__TEXT]
  }

  #---------------------------------------------------------------------------------------------
  # Write state transitions functionality

  #generic private write log register to process all state changes from the system
  def self.set(this_object, this_user, target_status, this_description)
    result=false
    if this_object and this_user and this_object.status
      new_reg=self.new(
          :description => this_description)
      new_reg.status = target_status
      new_reg.user = this_user
      if new_reg.save
        this_object.send("state_logs") << new_reg
        result=true
      else

      end
    else

    end
    return result
  end


end
