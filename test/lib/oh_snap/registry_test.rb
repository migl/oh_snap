# frozen_string_literal: true

require 'minitest/autorun'
require 'oh_snap/registry'
require 'oh_snap/identity_serializer'

class RegistryTest < Minitest::Test
  SNAPSHOTS_PATH = File.join(File.dirname(__FILE__))
  SNAPSHOTS_DIRNAME = '__snapshots__'

  def setup
    @serializer = OhSnap::IdentitySerializer.new
    @registry = OhSnap::Registry.new(path: SNAPSHOTS_PATH,
                                     serializer: @serializer,
                                     snapshots_dirname: SNAPSHOTS_DIRNAME,
                                     writable: true)
  end

  def test_snapshot_returns_snapshot_if_file_exists
    snapshot = @registry.snapshot(name: 'test')

    assert_equal snapshot.expected, "{\"a\":\"check file in __snapshots__/test.snap\"}\n"
  end

  def test_snapshot_returns_a_wildcard_snapshot_if_file_does_not_exist
    snapshot = @registry.snapshot(name: 'empty')

    assert_equal snapshot, 'anything'
    assert_equal snapshot.expected, 'anything'
    refute snapshot.touched?
  end

  def test_snapshot_returns_an_empty_snapshot_if_file_does_not_exist_and_registry_is_not_writable
    @registry = OhSnap::Registry.new(path: SNAPSHOTS_PATH,
                                     serializer: @serializer,
                                     snapshots_dirname: SNAPSHOTS_DIRNAME,
                                     writable: false)
    snapshot = @registry.snapshot(name: 'empty')

    refute_equal snapshot, 'anything'
    assert_equal snapshot.expected, ''
    assert_equal snapshot.actual, 'anything'
    assert snapshot.touched?
  end

  def test_snapshot_only_loads_file_once
    open_file_count = 0

    File.open(File.join(File.dirname(__FILE__), '__snapshots__', 'test.snap'), 'r') do |file|
      open_file_stub = lambda do |_path, _mode, &block|
        block.call(file)
        open_file_count += 1
      end

      File.stub(:open, open_file_stub) { 2.times { @registry.snapshot(name: 'test') } }
    end

    assert_equal 1, open_file_count
  end

  def test_save_writes_new_snapshot_file
    snapshot = @registry.snapshot(name: 'new_snapshot')

    assert_equal snapshot, 'value'

    file = Minitest::Mock.new
    file.expect :write, nil, ['value']

    File.stub :open, ->(_path, _mode, &block) { block.call(file) } do
      @registry.save
    end

    assert file.verify
  end

  def test_save_does_not_write_empty_snapshots
    snapshot = @registry.snapshot(name: 'empty')

    assert_equal snapshot, ''

    file = Minitest::Mock.new

    File.stub :open, ->(_path, _mode, &block) { block.call(file) } do
      @registry.save
    end

    assert file.verify
  end

  def test_save_writes_untouched_snapshot_to_file
    snapshot = @registry.snapshot(name: 'test')

    assert_equal snapshot, "{\"a\":\"check file in __snapshots__/test.snap\"}\n"

    file = Minitest::Mock.new
    file.expect :write, nil, ["{\"a\":\"check file in __snapshots__/test.snap\"}\n"]

    File.stub :open, ->(_path, _mode, &block) { block.call(file) } do
      @registry.save
    end

    assert file.verify
  end

  def test_save_writes_touched_snapshot_to_file
    snapshot = @registry.snapshot(name: 'test')

    refute_equal snapshot, 'new value'

    file = Minitest::Mock.new
    file.expect :write, nil, ['new value']

    File.stub :open, ->(_path, _mode, &block) { block.call(file) } do
      @registry.save
    end

    assert file.verify
  end

  def test_save_does_not_write_snapshot_to_file_if_registry_is_not_writable
    @registry = OhSnap::Registry.new(path: SNAPSHOTS_PATH,
                                     serializer: @serializer,
                                     snapshots_dirname: SNAPSHOTS_DIRNAME,
                                     writable: false)

    @registry.snapshot(name: 'test')

    file = Minitest::Mock.new

    File.stub :open, ->(_path, _mode, &block) { block.call(file) } do
      @registry.save
    end

    assert file.verify
  end
end
