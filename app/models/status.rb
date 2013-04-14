class Status < Cata

  SYSTEM_NAME = 'Status'
  TABLE_NAME = 'statuses'
  ENTITY_NAME = 'status'
  READABLE_NAME = 'Status'
  DB_DESCRIPTION = 'status'

  FIELDS = {
      :id => [DB__INTEGER],
      :system_name => [DB__STRING],
      :readable_name => [DB__STRING],
      :description => [DB__TEXT]
  }

  DEFAULT_VALUES = [
      {
          :system_name => 'created',
          :readable_name => 'created',
          :description => 'entry was just created'
      },
      {
          :system_name => 'completed',
          :readable_name => 'completed',
          :description => 'entry was completed'
      },
      {
          :system_name => 'closed',
          :readable_name => 'closed',
          :description => 'non editable data, item closed'
      },
      {
          :system_name => 'idle',
          :readable_name => 'idle',
          :description => 'user with no recent activity'
      },
      {
          :system_name => 'login',
          :readable_name => 'explicit logged in',
          :description => 'user last statement is logged in'
      },
      {
          :system_name => 'logout',
          :readable_name => 'explicit logged out',
          :description => 'user last statement is logged out'
      },
      {
          :system_name => 'confirm_email_sent',
          :readable_name => 'confirm email sent',
          :description => 'confirmation email was sent'
      },
      {
          :system_name => 'confirm_email_completed',
          :readable_name => 'confirm email completed',
          :description => 'confirmation email was completed'
      }
  ]

  def set object, performer
    object.status = self
    StateLog.set object, performer, self, 'a'
  end

  def get objects
    #return objects.where("status_id = '" + self.id.to_s + "'")
    return objects.select { |obj| obj.status_id == self.id }
  end

end
