require 'mini_magick'
require 'csv'
require "lencli/directory_search"
require "pry"

module LenCLI
  class GPSSearchAction
    def initialize(file_list)
      @file_list = file_list || []
    end

    def gps_data_from_files
      @file_list.map do |matching_path|
        image_name_and_coordinates(matching_path)
      end.compact
    end

    def image_name_and_coordinates(matching_path)
      image_metadata = MiniMagick::Image.open(matching_path)
      filename = File.basename(matching_path)

      [
        filename,
        image_metadata.exif["GPSLatitude"],
        image_metadata.exif["GPSLongitude"],
      ]
    rescue Errno::EACCES
      warn("WARNING: Missing required permissions to open #{matching_path}")
    rescue MiniMagick::Invalid
      warn("WARNING: #{matching_path} is not a valid image file")
    end
  end
end
