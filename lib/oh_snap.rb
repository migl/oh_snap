# frozen_string_literal: true

require 'oh_snap/identity_serializer'

# OhSnap is a library for managing snapshots in tests.
# In memory of Laurent "Lolo" Wauquier, who never missed an opportunity to say it.
module OhSnap
  # Configuration class for OhSnap.
  Configuration = Struct.new(:serializer, :snapshots_dirname, :writable) do
    alias_method :writable?, :writable
  end

  def self.config
    @config ||= Configuration.new.tap do |config|
      config.serializer = OhSnap::IdentitySerializer
      config.snapshots_dirname = '__snapshots__'
      config.writable = ENV.fetch('UPDATE_SNAPSHOTS', false)
    end
  end
end
