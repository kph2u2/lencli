require "lencli/services/callable/callable"

module LenCLI
  class FileMatcher
    attr_reader :file_list, :errors

    include LenCLI::Callable

    def initialize(options)
      @errors = []
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
        @errors << "#{@search_path} is not a valid directory to search"
      end
    end

    def set_matching_file_list
      @file_list ||= matching_files
    end

    def verify_matches_found
      unless @file_list&.any?
        @errors <<
          "No files found with suffix(es) #{@file_types} in #{@search_path}"
      end
    end

    def matching_files
      Dir.glob("#{@search_path}/**/*.{#{@file_types}}")
    end
  end
end
