require 'hyrax/ingest/errors'
require 'minitar'

module Hyrax
  module Ingest
    # A model for reading Submission Information Packages (SIPs) from a file_pathsystem.
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
      def file_paths
        @file_paths ||= single_file_path
        @file_paths ||= file_paths_from_dir
        @file_paths ||= file_paths_from_tarball
        @file_paths ||= []
      end

      # @param [String, Regexp] filename A string, a Regexp, or a string representation of a regex
      # @return [File] The file from the SIP that matches the param.
      def find_file_path(basename_or_regex)
        file_path = file_path_from_regex(basename_or_regex) || file_path_from_basename(basename_or_regex)
        raise Hyrax::Ingest::Errors::FileNotFoundInSIP.new(path, basename_or_regex) unless file_path
        file_path
      end

      # Reads the content of a file from the SIP, and automatically rewinds it
      # so it can be read again.
      # @param [String, Regexp] filename A string, a Regexp, or a string representation of a regex
      # @return [String] The contents of the matched file
      def read_file(basename_or_regex)
        File.read(find_file_path(basename_or_regex))
      end

      private

        # @param [String, Regexp] regex Either a Regexp object or a string
        #   beginning and ending in forward slashes, that can be converted to
        #   a regex.
        # @return [File] The file that matches regex as a regular expression;
        #   nil if no file matches 'regex', or if 'regex' cannot be used as a
        #   regular expression.
        def file_path_from_regex(regex)
          # If 'regex' is a string beginning and ending in slash, convert it to
          # a Regexp.
          regex = Regexp.new(regex.to_s[1..-2]) if regex.to_s =~ /^\/.*\/$/
          file_paths.find { |file| File.basename(file) =~ regex } if regex.is_a? Regexp
        end

        # @param [String] filename The name of the file within the SIP you want
        #   to return.
        # @return [File] The file that matches the 'filename' parameter; nil if
        #   no file matches the 'filename'.
        def file_path_from_basename(filename)
          file_paths.find { |file| File.basename(file) == filename }
        end

        # @return Array An Array containing the one and only file pointed to by #path
        def single_file_path
          Array(path) if File.file? path
        end

        def file_paths_from_dir
          if File.directory? path
            Dir.glob("#{path}/**/*").select { |entry| File.file? entry }
          end
        end

        def file_paths_from_tarball
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