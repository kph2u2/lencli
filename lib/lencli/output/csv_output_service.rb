require "lencli/output/base_output_service"

module LenCLI
  class CsvOutputService < BaseOutputService
		CSV_OPTIONS = {
			headers: ["Image File Name", "Lat", "Long"],
			write_headers: true
		}.freeze

		def to_csv
      CSV.open("/home/kyle/file.csv", "wb", CSV_OPTIONS) do |csv|
        @gps_list.each do |location_entry|
          csv << location_entry
        end
      end
    end
	end
end
