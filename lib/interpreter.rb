require "thor"
require "lencli/commander"
require "pry"

module LenCLI
	class Interpreter < Thor

		###################### VERSION #####################
		desc "version", "Display command-line version number."

		def version
			puts "Version: #{LenCLI::VERSION}"
		end

		###################### GPS_GRAB #####################
		method_option :output_format,
			default: "csv", enum: ["csv", "html"], :aliases => "-of"
		method_option :output_path,
			default: "./", :aliases => "-op"

		desc "gps_grab [SEARCH_PATH]",
				 "Extract gps coordinates from image files."

		long_desc <<~LONGDESC
			Recursively searches under the directory SEARCH_PATH for jpg images and
			extracts the gps latitude and longitude from the image file if location
			data is found.
			If a SEARCH_PATH is not provided, the current directory will be used as
			the starting point for the search.


			You can provide an optional parameter, --output_format="html", which will
			specify whether the generated results are CSV or HTML. The default value
			is the "csv" type.

			Examples:

				> $ gps_grab

				> $ gps_grab /home/my_home/search_directory

				> $ gps_grab /home/my_home/search_directory --output_format "html"

				> $ gps_grab /home/my_home/search_directory --op "/home/me/img.csv"
			LONGDESC

		def gps_grab(search_path=nil)
			Commander.find_images_extract_gps(search_path, options[:output_format])
		rescue Commander::CommanderError => error
			abort(error.message)
		end
	end
end
