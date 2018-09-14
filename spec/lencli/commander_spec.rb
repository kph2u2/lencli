require "spec_helper"
require "lencli/commander"
require "lencli/directory_search"

module LenCLI
  describe 'Commander' do
    describe '.find_images_extract_gps' do
      let(:options) {{ output_type: "csv" }}
      let(:search_path) { "home/search_me/" }
      let(:current_directory) { "./" }
      let(:matching_files) do
        [
          "#{search_path}/My_Filename_One",
          "#{search_path}/My_Filename_Two",
          "#{search_path}/My_Filename_Three",
        ]
      end
      let(:image_gps_data) do
        [
          ["My_Filename_One", "1234.89N", "787.45E"],
          ["My_Filename_Two", "7234.89N", "987.346"],
          ["My_Filename_Three", "5634.89N", "111.3464"],
        ]
      end
      before do
        allow(Dir)
          .to receive(:exists?).and_return(true)
        allow(DirectorySearch)
          .to receive(:find_files).and_return(matching_files)
        allow_any_instance_of(GPSSearchAction)
          .to receive(:gps_data_from_files).and_return(image_gps_data)
        allow_any_instance_of(CsvOutputService).to receive(:to_csv)
      end

      context 'the value provided to the search path parameter is nil' do
        let(:search_path) { nil }

        it 'uses the current directory as a default value' do
          expect(DirectorySearch)
            .to receive(:find_files).with(current_directory, anything)
          Commander.find_images_extract_gps(search_path, "csv")
        end
      end

      context 'the requested directory exists' do
        context 'when search path parameter is provided' do
          it 'passes the provided search path to DirectorySearch' do
            expect(DirectorySearch)
              .to receive(:find_files).with(search_path, anything)
            Commander.find_images_extract_gps(search_path, "csv")
          end
        end

        context 'when search path parameter is not provided' do
          it 'passes the current directory to DirectorySearch' do
            expect(DirectorySearch)
              .to receive(:find_files).with(current_directory, anything)
            Commander.find_images_extract_gps(nil, "csv")
          end
        end

        context 'when an optional file type is not specified' do
          it 'passes the default value "jpg" to DirectorySearch' do
            expect(DirectorySearch)
              .to receive(:find_files).with(anything, "jpg")
            Commander.find_images_extract_gps(nil, "csv")
          end
        end

        context 'when an optional file type is specified' do
          let(:supplied_file_type) { "png" }

          it 'passes the provided file type to DirectorySearch' do
            expect(DirectorySearch)
              .to receive(:find_files).with(anything, supplied_file_type)
            Commander.find_images_extract_gps(nil, "csv", supplied_file_type)
          end
        end

        context 'when nil value returned for a given file suffix search' do
          let(:matching_files) { nil }

          it 'raises an error with correct message' do
            expect {
              Commander.find_images_extract_gps(
                search_path,
                options,
              )
            }.to raise_error(
              Commander::CommanderError,
              "No files found with suffixes 'jpg'",
            )
          end
        end

        context 'when no files are found for a given file suffix' do
          let(:matching_files) { [] }
          let(:no_match_suffix) { "abc" }

          it 'raises an error with correct message' do
            expect {
              Commander.find_images_extract_gps(
                search_path,
                options,
                no_match_suffix,
              )
            }.to raise_error(
              Commander::CommanderError,
              "No files found with suffixes '#{no_match_suffix}'",
            )
          end
        end

        context 'when files are found for a given file suffix' do
          it 'passes the file list to the service to extract the gps data' do
            gps_action = double("GPSSearchAction")
            allow(gps_action)
              .to receive(:gps_data_from_files)
            csv_output = double("CsvOutputService")
            allow(csv_output)
              .to receive(:to_csv)
            allow(CsvOutputService)
              .to receive(:new).and_return(csv_output)

            expect(GPSSearchAction)
              .to receive(:new).with(matching_files).and_return(gps_action)
            Commander.find_images_extract_gps(search_path, "csv")
          end
        end

        context 'when nil value is provided for output_format' do
          it 'passes the default value "csv" to OutputService' do
            csv_output = double("CsvOutputService")
            allow(csv_output).to receive(:to_csv)

            expect(CsvOutputService)
              .to receive(:new).with("csv", anything).and_return(csv_output)
            Commander.find_images_extract_gps(nil, "csv")
          end
        end

        context 'when a valid list of gps coordinates are found' do
          it 'passes the list to the output service' do
            csv_output = double("CsvOutputService")
            allow(csv_output).to receive(:to_csv)

            expect(CsvOutputService)
              .to receive(:new).with(anything, image_gps_data)
              .and_return(csv_output)
            Commander.find_images_extract_gps(nil, "csv")
          end
        end
      end

      context 'the requested search directory does not exist' do
        before { allow(Dir).to receive(:exists?).and_return(false) }

        it 'raises an error with a message specifying the missing directory' do
          expect {
            Commander.find_images_extract_gps(search_path, options)
          }.to raise_error(
            Commander::CommanderError,
            "#{search_path} is not a valid directory",
          )
        end
      end
    end
  end
end
