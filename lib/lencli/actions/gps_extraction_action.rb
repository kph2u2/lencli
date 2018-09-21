require "mini_magick"
require "lencli/services/callable/callable"

module LenCLI
  class GPSExtractionAction
    attr_reader :results

    include LenCLI::Callable

    def initialize(file_list)
      @errors = []
      @file_list = file_list || []
    end

    def call
      extract_gps_coordinates_from_image_files
      self
    end

    def headers
      ["Image Filename", "Lat", "Lat Ref", "Long", "Long Ref"]
    end

    private

    def extract_gps_coordinates_from_image_files
      @results ||= gps_data_from_files.compact.sort
    end

    def gps_data_from_files
      @file_list.map do |matching_path|
        image_name_and_coordinates(matching_path)
      end
    end

    def image_name_and_coordinates(matching_path)
      image_metadata = MiniMagick::Image.open(matching_path)
      filename = File.basename(matching_path)

      [
        filename,
        image_metadata.exif["GPSLatitude"],
        image_metadata.exif["GPSLatitudeRef"],
        image_metadata.exif["GPSLongitude"],
        image_metadata.exif["GPSLongitudeRef"],
      ]
    rescue Errno::EACCES
      warn("WARNING: Missing required permissions to open #{matching_path}")
    rescue MiniMagick::Invalid
      warn("WARNING: #{matching_path} is not a valid image file")
    rescue MiniMagick::Error => error
      warn("WARNING: #{matching_path} caused #{error.message}")
    end
  end
end
