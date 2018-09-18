require "lencli/output/base_output_service"
require "csv"

module LenCLI
  class CsvActionOutput < BaseOutputService
    def output
      CSV.generate(csv_options) do |csv|
        @action.results.each do |location_entry|
          csv << location_entry
        end
      end
    end

    private

    def csv_options
      {
        headers: @action.headers,
        write_headers: true,
      }
    end
  end
end
