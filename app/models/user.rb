require 'bcrypt'

class User < Cata
  # attr_accessible :title, :body
  ##################################################
  #Model Constants
  SYSTEM_NAME = 'User'
  TABLE_NAME = 'users'
  ENTITY_NAME = 'user'
  READABLE_NAME = 'User'
  DB_DESCRIPTION = 'user'

  has_and_belongs_to_many :state_logs
  belongs_to :status

  has_many :companies

  FIELDS = {
      :id => [DB__INTEGER],
      :system_name => [DB__STRING],
      :first_name => [DB__STRING],
      :last_name => [DB__STRING],
      :encrypted_password => [DB__STRING],
      :description => [DB__TEXT],
      :status_id => [DB__INTEGER],
      :last_login_fails_count => [DB__INTEGER],
      :last_activity_at => [DB__DATE_TIME],
      :last_login_try_at => [DB__DATE_TIME],
      :last_login_success_at => [DB__DATE_TIME],
      :last_logout_at => [DB__DATE_TIME]
  }

  #<editor-fold desc="CONSTANTS">
  ACTION_LOGIN_CONSTRAINTS = {
      :condition =>
          {
              :submit =>
                  {
                      :class => 'cata_inactive',
                      :blocking => true
                  }
          },
      :data => {
          :user_name => {
              :length => {
                  :min => 1,
                  :max => 15
              }
          },
          :password => {
              :length => {
                  :min => 1,
                  :max => 15
              }
          }
      }
  }

  ACTION = {
      :submit_login =>
          {:submit_form =>
               {
                   :events => ['click'],
                   :constraints => ACTION_LOGIN_CONSTRAINTS
               }
          },
      :input_login =>
          {:refresh_feedback =>
               {
                   :events => ['keyup'],
                   :constraints => ACTION_LOGIN_CONSTRAINTS
               }
          }


  }

#</editor-fold>

  DEFAULT_VALUES = [
      {
          :system_name => 'automata@tipsharepro.com',
          :first_name => 'automata',
          :last_name => '00000',
          :description => 'automated system'
      }
  ]

  def self.cata
    return self.find 1
  end

#
# +user_name+::
# +password+::
# +return+::
  def self.authenticate user_name, password
    if this_subscriber = self.get(user_name)
      current=BCrypt::Password.new(this_subscriber.encrypted_password)
      this_subscriber.last_login_try_at = Time.now
      if current == password
        this_subscriber.last_login_success_at = Time.now
        Status.get('login').set this_subscriber, this_subscriber
        this_subscriber.save
        return this_subscriber
      else
        this_subscriber.last_login_fails_count += 1
        this_subscriber.save
        return nil
      end
    end

    return nil
  end

#
# +user_name+::
# +password+::
# +return+::
  def self.signup params
    if this_subscriber = self.new
      this_subscriber.first_name = params[:first_name]
      this_subscriber.last_name = params[:last_name]
      this_subscriber.system_name = params[:user_name]
      this_subscriber.encrypted_password = params[:password]
      this_subscriber.process_password
      this_subscriber.last_login_fails_count = 0
      if this_subscriber.save
        Status.get('created').set this_subscriber, this_subscriber
        this_subscriber.save
        return this_subscriber
      else
        return nil
      end
    end
    return nil
  end

  def self.session_member user_id
    user_found = nil
    if user_id and user_id > 0
      begin
        user_found=self.find(user_id)
      rescue

      end
    end
    return user_found
  end


  #encrypt password to be stored for the member
  def process_password
    password = BCrypt::Password.create(self.encrypted_password, :cost => 10)
    self.encrypted_password = password
  end

end
