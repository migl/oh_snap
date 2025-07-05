# frozen_string_literal: true

require 'oh_snap'
require 'oh_snap/registry'

module OhSnap
  # Helper methods for OhSnap to be included in test suites.
  module Helper
    def setup_snapshots(path:,
                        serializer: OhSnap.config.serializer.new,
                        snapshots_dirname: OhSnap.config.snapshots_dirname,
                        writable: OhSnap.config.writable?)
      @ohsnapshots = Registry.new(path: path,
                                  serializer: serializer,
                                  snapshots_dirname: snapshots_dirname,
                                  writable: writable)
    end

    def snapshot(name:)
      @ohsnapshots.snapshot(name: name)
    end

    def snapshot_matches(actual, name:)
      snapshot(name: name) == actual
    end

    def save_snapshots
      @ohsnapshots&.save
    end
  end
end
