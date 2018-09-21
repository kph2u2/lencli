require "mini_magick"
require "lencli/services/callable/callable"

module LenCLI
  class GPSExtractionAction
    attr_reader :results

    include LenCLI::Callable

    def initialize(file_list, filter_missing=false)
      @file_list = file_list || []
      @filter_missing = filter_missing
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
      exif = MiniMagick::Image.open(matching_path).exif
      filename = File.basename(matching_path)

      return nil if !exif_exists?(exif) && @filter_missing

      [
        filename,
        exif["GPSLatitude"],
        exif["GPSLatitudeRef"],
        exif["GPSLongitude"],
        exif["GPSLongitudeRef"],
      ]
    rescue Errno::EACCES
      warn("WARNING: Missing required permissions to open #{matching_path}")
    rescue MiniMagick::Invalid
      warn("WARNING: #{matching_path} is not a valid image file")
    rescue MiniMagick::Error => error
      warn("WARNING: #{matching_path} caused #{error.message}")
    end

    def exif_exists?(exif)
      exif &&
      (exif.key?("GPSLatitude") ||
      exif.key?("GPSLatitudeRef") ||
      exif.key?("GPSLongitude") ||
      exif.key?("GPSLongitudeRef"))
    end
  end
end
