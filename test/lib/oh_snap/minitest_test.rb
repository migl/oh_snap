# frozen_string_literal: true

require 'minitest/autorun'
require 'oh_snap/minitest'

class TestOhSnapMinitest < Minitest::Test
  include OhSnap::Minitest

  def test_asserts_equality_with_named_snapshot
    assert_equal snapshot(name: 'named_snapshot'), 'expected value'
  end

  def test_asserts_equality_with_default_snapshot
    assert_equal snapshot, 'expected value'
  end

  def test_refutes_equality_in_inverted_comparison
    refute_equal 'expected value', snapshot
  end
end
