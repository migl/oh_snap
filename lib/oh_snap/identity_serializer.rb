# frozen_string_literal: true

require_relative 'base_serializer'

module OhSnap
  # Returns `value` as is, without any transformation.
  # `value` must be writable to a file.
  class IdentitySerializer < BaseSerializer
    def serialize(value)
      value
    end
  end
end
