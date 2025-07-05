# frozen_string_literal: true

require_relative 'snapshot'

module OhSnap
  # Serializes and loads Snapshot objects.
  class BaseSerializer
    def serialize(value)
      raise NotImplementedError, "#{self.class} must implement #serialize"
    end

    def load(value)
      Snapshot.new(value, serializer: self)
    end
  end
end
