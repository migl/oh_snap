# frozen_string_literal: true

module OhSnap
  # Registry is responsible for managing snapshots during a test run.
  class Registry
    def initialize(path:, serializer:, snapshots_dirname:, writable:)
      @path = path
      @serializer = serializer
      @snapshots_dirname = snapshots_dirname
      @writable = writable
      @snapshots = {}
    end

    def snapshot(name:)
      return @snapshots[name] if @snapshots&.key?(name)

      unless File.exist?(snapshot_path(name))
        return @snapshots[name] = @serializer.load('') unless writable?

        return @snapshots[name] = @serializer.load(nil)
      end

      File.open(snapshot_path(name), 'r') do |file|
        @snapshots[name] = @serializer.load(file.read)
      end

      @snapshots[name]
    end

    def save
      return unless writable?

      Dir.mkdir(snapshots_path) unless Dir.exist?(snapshots_path)

      @snapshots.each do |name, snapshot|
        dump(name, snapshot)
      end
    end

    private

    def writable?
      @writable
    end

    def dump(name, snapshot)
      value = snapshot.touched? ? snapshot.actual : snapshot.expected
      return if value.nil? || value.empty?

      File.open(snapshot_path(name), 'w') do |file|
        file.write(value)
      end
    end

    def snapshot_path(name)
      File.join(snapshots_path, "#{name}.snap")
    end

    def snapshots_path
      @snapshots_path ||= File.join(@path, @snapshots_dirname)
    end
  end
end
