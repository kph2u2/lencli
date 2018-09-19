require "spec_helper"
require "lencli/commander/commander"
require "lencli/services/file_matcher"

describe LenCLI::Commander do
  describe ".gps_grab" do
    let(:subject) { described_class.gps_grab(options) }
    let(:options) {{ search_path: search_path, output_format: "csv" }}
    let(:search_path) { "home/search_me/" }
    let(:matching_files) do
      [
        "#{search_path}/My_Filename_One",
        "#{search_path}/My_Filename_Two",
        "#{search_path}/My_Filename_Three",
      ]
    end

    let(:file_svc) { double(LenCLI::FileMatcher) }
    let(:output_svc) { double(LenCLI::ActionOutputService) }
    let(:action_svc) { double(LenCLI::GPSExtractionAction) }

    before do
      allow(LenCLI::FileMatcher)
        .to receive(:call).and_return(file_svc)
      allow(file_svc)
        .to receive(:successful?).and_return(true)
      allow(file_svc)
        .to receive(:file_list).and_return(matching_files)

      allow(LenCLI::GPSExtractionAction)
        .to receive(:call).and_return(action_svc)

      allow(LenCLI::ActionOutputService)
        .to receive(:call).and_return(output_svc)
      allow(output_svc)
        .to receive(:successful?).and_return(true)
    end

    context "the file matcher service" do
      context "successfully finds a list of matching files" do
        it "passes the file list to GPSExtractionAction" do
          expect(LenCLI::GPSExtractionAction)
            .to receive(:call).with(matching_files)
          subject
        end

        it "passes the gps search action and options to ActionOutputService" do
          expect(LenCLI::ActionOutputService)
            .to receive(:call).with(action_svc, options)
            .and_return(output_svc)
          subject
        end
      end

      context "encounters an error condition" do
        let(:error_message) { "An error occurred" }

        it "raises a CommanderError with correct error message" do
          allow(file_svc)
            .to receive(:successful?).and_return(false)
          allow(file_svc)
            .to receive(:errors).and_return([error_message])

          expect{ subject }
            .to raise_error(
              LenCLI::Commander::CommanderError, /"#{error_message}"/
            )
        end
      end
    end

    context "the action output service" do
      context "generates the output for the action" do
        it "no exception is raised" do
          expect{ subject }.not_to raise_error
        end
      end

      context "encounters an error generating the output for the action" do
        let(:error_message) { "An error occurred" }

        it "raises a CommanderError with correct error message" do
          allow(output_svc)
            .to receive(:successful?).and_return(false)
          allow(output_svc)
            .to receive(:errors).and_return([error_message])

          expect{ subject }
            .to raise_error(
              LenCLI::Commander::CommanderError, /"#{error_message}"/
            )
        end
      end
    end
  end
end
