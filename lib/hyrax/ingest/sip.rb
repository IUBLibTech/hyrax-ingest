require 'hyrax/ingest/errors'
require 'minitar'

module Hyrax
  module Ingest
    # A model for reading Submission Information Packages (SIPs) from a filesystem.
    #
    # @attr_reader [String] path description of a readonly attribute
    class SIP
      attr_reader :path

      # @param [String] path The path to the SIP on the filesystem.
      def initialize(path:)
        raise Hyrax::Ingest::Errors::InvalidSIPPath.new(path.to_s) unless File.exists? path.to_s
        @path = path
      end

      # @return [Array] A list of File objects that are part of the SIP
      def files
        @files ||= single_file
        @files ||= files_from_dir
        @files ||= files_from_tarball
        @files ||= []
      end

      private

        # @return Array An Array containing the one and only file pointed to by #path
        def single_file
          [File.new(path)] if File.file? path
        end

        def files_from_dir
          if File.directory? path
            Dir.glob("#{path}/**/*").select { |entry| File.file? entry }.map{ |entry| File.new(entry) }
          end
        end

        def files_from_tarball
          # TODO: this is the best test I could find for reliably determining
          # whether a file was a TAR archive or not, but it seems finicky, as
          # it probably depends on your operating system, or what kind of tarball
          # it is. Find something better?
          if (`file '#{path}'` =~ /tar archive/)
            Minitar.unpack(path, tmp_dir_for_unpacked_tarball)
            Dir.glob("#{tmp_dir_for_unpacked_tarball}/**/*")
          end
        end

        def tmp_dir_for_unpacked_tarball
          "#{Dir.tmpdir}/#{File.basename(path)}.unpacked"
        end
    end
  end
end