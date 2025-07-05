# frozen_string_literal: true

require 'oh_snap/helper'

module OhSnap
  # OhSnap helper for Minitest.
  module Minitest
    include OhSnap::Helper

    def before_setup
      super
      setup_snapshots(path: File.dirname(File.expand_path(method(name).source_location.first)))
    end

    def snapshot(name: nil)
      super(name: name || self.name)
    end

    def after_teardown
      save_snapshots
      super
    end
  end
end
