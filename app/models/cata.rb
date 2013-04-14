require 'action_view'
include ActionView::Helpers::NumberHelper

class Cata < ActiveRecord::Base
  self.abstract_class = true

  NA = nil
  DB__INTEGER = 'integer'
  DB__REF = 'ref'
  DB__STRING = 'string'
  DB__TEXT = 'text'
  DB__DATE = 'date'
  DB__BOOLEAN = 'boolean'
  DB__DATE_TIME = 'datetime'


  UI={
      :style => {
          :path_prefix => 'base/startup/'
      },
      :element => {
          :text_box => 'text_box',
          :long_text_box => 'long_text_box',
          :password => 'password',
          :text => 'text_area',
          :button => 'button'
      },
      :action => {
          :submit_form => 'submit_form'
      }
  }

  #static method used to define models fields in the model app and get the configuration on the DB migration automatically
  def self.schema_based_on_model(migration_obj, entity_class, explicit_id=false)
    if explicit_id
      # schema implementation with explicit ID declaration
      migration_obj.create_table entity_class::TABLE_NAME, :id => false do |t|
        entity_class::FIELDS.each do |this_field, these_attributes|
          t.column this_field, these_attributes[0]
        end
        t.timestamps
      end
      # end of schema implementation
    else
      # schema implementation with implicit ID declaration
      migration_obj.create_table entity_class::TABLE_NAME do |t|
        entity_class::FIELDS.each do |this_field, these_attributes|
          if this_field.to_s != 'id'
            t.column this_field, these_attributes[0]
          end
        end
        t.timestamps
      end
      # end of schema implementation
    end

  end

  def self.create_seeds
    if self.const_defined?('DEFAULT_VALUES')
      self.create(self::DEFAULT_VALUES)
    end
  end

  #---------------------------------------------------------------------------------------------

  #---------------------------------------------------------------------------------------------
  # Framework helpers

  #generate password
  def self.generate_password
    chars = ('a' .. 'z').to_a + ('A' .. 'Z').to_a + ('1' .. '9').to_a + '%_$?@!'.split(//)
    Array.new(PASSWORD_LENGTH, '').collect { chars[rand(chars.size)] }.join
  end

  #generate name
  def self.generate_name
    chars = ('a' .. 'z').to_a + ('A' .. 'Z').to_a + ('1' .. '9').to_a
    Array.new(NAME_LENGTH, '').collect { chars[rand(chars.size)] }.join
  end

  #generate name
  def self.generate_safe_name
    chars = ('a' .. 'z').to_a
    Array.new(5, '').collect { chars[rand(chars.size)] }.join
  end

  #method used as macro to find by system name using the Static method get
  def self.get(system_name_string)
    return self.find_by_system_name(system_name_string)
  end

  def amount
    try_cents = cents || nil
    if try_cents and try_cents != 0
      return try_cents.to_f/100
    else
      return 0
    end
  end

  def readable_amount
    return number_with_delimiter amount
  end
end
