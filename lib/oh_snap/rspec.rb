# frozen_string_literal: true

require 'oh_snap/helper'

module OhSnap
  # OhSnap helper for RSpec.
  module RSpec
    include OhSnap::Helper

    def self.included(rspec)
      rspec.before do
        setup_snapshots(path: File.dirname(File.expand_path(rspec.location)))
      end

      rspec.after do
        save_snapshots
      end
    end

    def snapshot(name: nil)
      name ||= ::RSpec.current_example
                      .full_description
                      .tr("%$|/:;<>?*#\"\t\r\n\\", '-')
                      .tr(' ', '_')
                      .strip
      super(name: name)
    end
  end
end
