# frozen_string_literal: true

require "json-schema"

class BaseValidator
  SCHEMA_JSON = 'lib/validators/schemas/schema.json'

  def validate(params)
    JSON::Validator.validate(SCHEMA_JSON, params) && destroyer_param_present?(params)
  end

  private

  def destroyer_param_present?(params)
    params[:expire_hours].to_i.between?(1, 24) || params[:click_striker].to_i.between?(1, 24)
  end
end
