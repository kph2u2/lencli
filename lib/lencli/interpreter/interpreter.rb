require "thor"
require "lencli/commander/commander"
require "lencli/version/version"

module LenCLI
  class Interpreter < Thor

    ###################### VERSION #####################
    desc "version", "Display command-line version number."

    def version
      puts "Version: #{LenCLI::VERSION}"
    end

    ###################### GPS_GRAB #####################
    method_option :output_format,
      default: "csv", enum: ["csv", "html"], :aliases => "--of"
    method_option :output_path,
      default: "./lencli_output", :aliases => "--op"
    method_option :file_types,
      default: "jpg", :aliases => "--ft"
    method_option :filter_missing,
      default: "false", :aliases => "--fm", type: :boolean

    desc "gps_grab [SEARCH_PATH]",
         "Extract gps coordinates from image files."

    long_desc <<~LONGDESC
      Recursively searches under the directory SEARCH_PATH for jpg files and
      extracts the gps latitude and longitude from the image file if location
      data is found.
      If a SEARCH_PATH is not provided, the current directory will be used as
      the starting point for the search.


      Optional parameter --output-format=OUTPUT_FORMAT will specify whether
      the generated results are CSV or HTML. The default value is the "csv"
      type.

      Optional parameter --output-path=OUTPUT_PATH will specify the destination
      output file location. The default value is "./lencli_output".

      Optional parameter --file-types=FILE_TYPES will specify the image file
      suffixes that will be used to search for exif data. The default value is
      "jpg".

      Optional parameter --filter-missing or --no-filter-missing is a boolean
      value to determine whether the returned data will filter results where
      there is no exif data present.

      Examples:

        > $ gps_grab

        > $ gps_grab /home/my_home/search_directory

        > $ gps_grab /home/my_home/search_directory --output_format "html"

        > $ gps_grab /home/my_home/search_directory --op "/home/me/img.csv"
      LONGDESC

    def gps_grab(search_path=nil)
      Commander.gps_grab(options.merge(search_path: search_path))
    rescue Commander::CommanderError => error
      abort("Fatal error: #{error.message}")
    end
  end
end
