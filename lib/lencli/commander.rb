require "lencli/directory_search"
require "lencli/action/gps_search_action"
require "lencli/output/csv_output_service"
require "pry"

module LenCLI
  class Commander

    class CommanderError < StandardError; end

    def self.find_images_extract_gps(search_path, output_format, file_types="jpg")
      
      search_path ||= "./"
      output_format ||= "csv"

      unless Dir.exists?(search_path)
        raise CommanderError, "#{search_path} is not a valid directory"
      end

      matching_file_list = DirectorySearch.find_files(search_path, file_types)

      unless matching_file_list&.any?
        raise CommanderError, "No files found with suffixes '#{file_types}'"
      end

      gps_coordinates =
        GPSSearchAction.new(matching_file_list).gps_data_from_files

      CsvOutputService.new(output_format, gps_coordinates).to_csv
    end
  end
end
