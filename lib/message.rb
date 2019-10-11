# frozen_string_literal: true

require_relative 'validators/base_validator'
require_relative 'mutators/message_mutator'
require_relative '../lib/services/message_service'

class Message
  attr_reader :params, :validator, :valid

  ACCESS_KEYS = %i[body expire_hours click_striker].freeze

  def initialize(params, validator = BaseValidator.new)
    @params = params.slice(*ACCESS_KEYS)
    @valid = validator.validate(params)
  end
end
