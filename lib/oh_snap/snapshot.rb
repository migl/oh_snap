# frozen_string_literal: true

module OhSnap
  # Represents a snapshot
  class Snapshot
    attr_reader :actual, :expected, :matched

    def initialize(expected = nil, serializer:)
      @actual = nil
      @expected = expected
      @serializer = serializer
    end

    def ==(other)
      @actual = serialize(other)
      @expected ||= serialize(other)
      @matched = @expected == @actual
    end

    def touched?
      defined?(@matched) && !@matched
    end

    def inspect
      @expected.inspect
    end

    private

    def serialize(value)
      @serializer.serialize(value)
    end
  end
end
