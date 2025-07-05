# frozen_string_literal: true

require 'minitest/autorun'
require 'oh_snap/snapshot'
require 'oh_snap/identity_serializer'

class SnapshotTest < Minitest::Test
  def setup
    @serializer = OhSnap::IdentitySerializer.new
    @snapshot = OhSnap::Snapshot.new('serializable value', serializer: @serializer)
  end

  def test_equality_returns_true_if_values_are_equal
    assert @snapshot == 'serializable value'
  end

  def test_equality_returns_false_if_values_are_not_equal
    refute @snapshot == 'different value'
  end

  def test_equality_stores_actual_value
    refute @snapshot == 'different value'

    assert_equal 'different value', @snapshot.actual
  end

  def test_equality_stores_actual_value_as_expected_when_snapshot_is_empty
    snapshot = OhSnap::Snapshot.new(nil, serializer: @serializer)

    assert snapshot == 'new value'
    assert_equal 'new value', snapshot.expected
    assert_equal 'new value', snapshot.actual
  end

  def test_equality_sets_the_snapshot_as_touched
    refute @snapshot == 'different value'

    assert @snapshot.touched?
  end
end
