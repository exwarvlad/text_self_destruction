# frozen_string_literal: true

require_relative 'validators/base_validator'
require_relative 'mutators/message_mutator'
require_relative '../lib/services/message_service'

class Message
  attr_reader :params, :validator, :valid

  ACCESS_KEYS = %i[body expire_hours click_striker].freeze
  INTEGER_KEYS = %i[expire_hours click_striker].freeze

  def initialize(params, validator = BaseValidator.new)
    @params = JSON(params.to_json, symbolize_names: true)
    @params.slice!(*ACCESS_KEYS).delete_if { |_k, v| v.blank? }
    INTEGER_KEYS.each { |k| @params[k] = @params[k].to_i if @params[k] }
    @valid = validator.validate(@params)
  end
end
