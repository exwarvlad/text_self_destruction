# frozen_string_literal: true

require_relative 'base_validator'

class Message
  attr_reader :params, :validator

  ACCESS_KEYS = %i[body expire_hours click_striker].freeze

  def initialize(params, validator = BaseValidator.new)
    @params = params.slice(ACCESS_KEYS)
    @valid = validator.validate(params).validate
  end

  def call
    return unless @valid

    # todo
  end
end