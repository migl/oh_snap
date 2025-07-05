# frozen_string_literal: true

require 'minitest/autorun'
require 'oh_snap/helper'

class TestOhSnapHelper < Minitest::Test
  include OhSnap::Helper

  def before_setup
    super
    setup_snapshots(path: File.dirname(__FILE__))
  end

  def after_teardown
    save_snapshots
    super
  end

  def test_asserts_equality_with_named_snapshot
    assert_equal snapshot(name: 'named_snapshot'), 'expected value'
  end

  def test_asserts_equality_with_default_snapshot
    assert_equal snapshot(name: 'test_asserts_equality_with_default_snapshot'), 'expected value'
  end

  def test_refutes_equality_in_inverted_comparison
    refute_equal 'expected value', snapshot(name: 'test_refutes_equality_in_inverted_comparison')
  end
end
