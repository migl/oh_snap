# frozen_string_literal: true

require 'minitest/autorun'
require 'oh_snap/identity_serializer'

class IdentitySerializerTest < Minitest::Test
  def setup
    @serializer = OhSnap::IdentitySerializer.new
  end

  def test_serialize_returns_value_as_is
    value = 1_000
    serialized_value = @serializer.serialize(value)

    assert_same value, serialized_value
  end
end
