require "lencli/services/callable/callable"

module LenCLI
  class FileMatcher
    attr_reader :file_list

    include LenCLI::Callable

    def initialize(options)
      @search_path = options[:search_path] || "./"
      @file_types = options[:file_types] || "jpg"
    end

    def call
      verify_search_directory_exists
      return self unless successful?

      set_matching_file_list
      verify_matches_found
      self
    end

    private

    def verify_search_directory_exists
      unless Dir.exists?(@search_path)
        add_error("#{@search_path} is not a valid directory to search")
      end
    end

    def set_matching_file_list
      @file_list ||= matching_files
    end

    def verify_matches_found
      unless @file_list&.any?
        add_error(
          "No files found with suffix(es) #{@file_types} under #{@search_path}"
        )
      end
    end

    def matching_files
      Dir.glob("#{@search_path}/**/*.{#{@file_types}}")
    end
  end
end
