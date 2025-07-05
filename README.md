# OhSnap

**OhSnap** is a Ruby gem for snapshot testing with helpers for Minitest and RSpec to name snapshot files after the tests that create them.
It is built to be asserted via the equality comparator so you can use any assertion that you like that is based on it.

## Features

- **Compare snapshots with `#==`**: No special assertions are needed; just use equality syntax.
- **Split in multiple files**: Stores snapshots in separate files for easy inspection.
- **Automatic snapshot naming for Minitest and RSpec**: Automatically names snapshot files based on the test name.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oh_snap'
```

and then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install oh_snap
```

## Usage

Use the `OhSnap::Helper` to set up your snapshot registry on every test run:

```ruby
require 'oh_snap/helper'

class MyTest < Test::Unit::TestCase
  include OhSnap::Helper

  def startup
    super
    setup_snapshots(path: File.dirname(__FILE__))
  end

  def test_a_snapshot_matches
    assert_equal snapshot(name: 'snapshot_name'), 'some value'
  end

  def shutdown
    save_snapshots
    super
  end
end
```

You are responsible for specifying the base location for the `__snapshots__` directory in the `path:` argument and naming your snapshots passing `name:` in each call to `#snapshot`.

Bear in mind that order is important when comparing snapshots to values:

```ruby
# Bad
assert 'something' == snapshot
assert_equal 'something', snapshot

# Good
assert snapshot == 'something'
assert_equal snapshot, 'something'
```

If you really do not care about choosing your assertion, use the `snapshot_matches` helper method included with `OhSnap::Helper`:

```ruby
assert snapshot_matches('something')
expect(snapshot_matches('something')).to be true
```

### Minitest and RSpec

Helpers for RSpec and Minitest make things easier because they name the snapshot file automagically based on the test name:

#### Minitest

In your test file:

```ruby
require 'minitest/autorun'
require 'oh_snap/minitest'

class MyTest < Minitest::Test
  include OhSnap::Minitest

  def test_example
    result = perform_complex_operation
    assert snapshot == result
  end

    def test_example_with_assert_equal
    result = perform_complex_operation
    assert_equal snapshot, result
  end

  def test_example_with_matcher
    result = perform_complex_operation
    assert snapshot_matches(result)
  end

  def test_custom_named_snapshot
    result = perform_another_operation
    assert_equal snapshot(name: 'custom_snapshot_name'), result
  end

  def test_custom_named_snapshot_with_matcher
    result = perform_another_operation
    assert snapshot_matches(result, name: 'custom_snapshot_name')
  end
end
```

#### RSpec

In your test file:

```ruby
require 'oh_snap/rspec'

RSpec.configure do |config|
  config.include OhSnap::RSpec
end

RSpec.describe 'My feature' do
  it 'produces the correct output' do
    result = perform_complex_operation
    expect(snapshot).to eq result
  end

  it 'also produces the correct output' do
    result = perform_complex_operation
    expect(snapshot_matches(result)).to be true
  end

  it 'produces the correct output with custom snapshot name' do
    result = perform_another_operation
    expect(snapshot(name: 'custom_snapshot_name')).to eq result
  end

  it 'also produces the correct output with custom snapshot name' do
    result = perform_another_operation
    expect(snapshot_matches(result, name: 'custom_snapshot_name')).to be true
  end
end

```

In both cases, snapshots will be saved in the `__snapshots__` directory adjacent to the test file.

## Updating Snapshots

To update existing snapshots, set the `UPDATE_SNAPSHOTS` environment variable:

```bash
UPDATE_SNAPSHOTS=1 bundle exec rake test
```

This will regenerate snapshots for tests that fail due to mismatches.

Notice that setting any value for `UPDATE_SNAPSHOTS` will be interpreted as setting the write mode as `true`.
If you do not want to update snapshots, do not set `UPDATE_SNAPSHOTS` at all.
The latter should be the case in your CI environment.

## Configuration

Global configuration can be set via `OhSnap.config`:
```ruby
OhSnap.config.tap do |config|
  config.serializer = OhSnap::IdentitySerializer # Should inherit from OhSnap::BaseSerializer and implement #serialize.
  config.snapshots_dirname = '__snapshots__' # Sets the name for the directory used to store snapshots.
  config.writable = false # Sets the write/update mode. `true` if the UPDATE_SNAPSHOTS environment variable is set.
end
```

### Write your own serializer

Using `IdentitySerializer` forces you to compare stringified values to snapshots.
If you need to serialize non-string objects, you can write your own serializer inheriting from `OhSnap::BaseSerializer` and implementing the `#serialize` method to return a string.

```ruby
require 'json'

class MyJSONSerializer < OhSnap::BaseSerializer
  def serialize(value)
    JSON.dump(value)
  end
end
```

You can then use `setup_snapshots` in your test to use your new serializer:

```ruby
def setup
  setup_snapshots(serializer: MyJSONSerializer)
end

def test_it_renders_the_expected_json_body
  json_value = render_json_value
  assert_equal snapshot, json_value
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/migl/oh_snap.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
