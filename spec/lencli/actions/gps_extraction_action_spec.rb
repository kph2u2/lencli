require "spec_helper"
require "lencli/actions/gps_extraction_action"
require "mini_magick"

describe "GPSExtractionAction" do
  describe ".call" do
    before do
      allow(MiniMagick::Image)
        .to receive(:open).and_return(image_object)
      allow(File)
        .to receive(:basename)
        .and_return("image_file_1", "image_file_2", "image_file_3")
      allow(image_object)
        .to receive(:exif).and_return(*image_metadata)
    end
    let(:image_metadata) do
      [
        {
          "GPSLatitude" => "38,24,0N",
          "GPSLatitudeRef" => "N",
          "GPSLongitude" => "10,41.735887E",
          "GPSLongitudeRef" => "W",
        },
        {
          "GPSLatitude" => "50,11,5N",
          "GPSLatitudeRef" => "N",
          "GPSLongitude" => "05,99.8734892E",
          "GPSLongitudeRef" => "E",
        },
        {
        },
      ]
    end
    let(:image_object) { double("MiniMagick::Image") } 
    let(:file_list) {
      [
        "/home/image_file_1",
        "/home/image_file_2",
        "/home/image_file_3",
      ]
    } 
    let(:filter_missing) { false }
    let(:subject) do
      LenCLI::GPSExtractionAction.call(file_list, filter_missing).results
    end

    context "a valid file list value" do
      let(:expected_gps_data) do
        [
          ["image_file_1", "38,24,0N", "N", "10,41.735887E", "W"],
          ["image_file_2", "50,11,5N", "N", "05,99.8734892E", "E"],
          ["image_file_3", nil, nil, nil, nil],
        ]
      end

      it "returns a list with all gps data" do
        is_expected.to eq(expected_gps_data)
      end

      context "with filter missing option set to true" do
        let(:filter_missing) { true }
        let(:expected_gps_data) do
          [
            ["image_file_1", "38,24,0N", "N", "10,41.735887E", "W"],
            ["image_file_2", "50,11,5N", "N", "05,99.8734892E", "E"],
          ]
        end

        it "returns a list of gps data that contain exif entries" do
          is_expected.to eq(expected_gps_data)
        end
      end
    end

    context "a nil file list value" do
      let(:file_list) { nil } 
      
      it "returns an empty list of gps data" do
        is_expected.to eq([])
      end
    end

    context "an empty array file list value" do
      let(:file_list) { [] } 
      
      it "returns an empty list of gps data" do
        is_expected.to eq([])
      end
    end

    context "user lacks permissions" do
      before do
        allow(MiniMagick::Image).to receive(:open).and_raise(Errno::EACCES)
        allow($stderr).to receive(:write)
      end
      
      it "returns an empty list of gps data" do
        is_expected.to eq([])
      end

      it "outputs a warning message to standard error" do
        expect { subject }.to output(/Missing required permissions/).to_stderr
      end
    end

    context "invalid image file contents" do
      before do
        allow(MiniMagick::Image)
          .to receive(:open).and_raise(MiniMagick::Invalid)
        allow($stderr).to receive(:write)
      end
      
      it "returns an empty list of gps data" do
        is_expected.to eq([])
      end

      it "outputs a warning message to standard error" do
        expect { subject }.to output(/is not a valid image file/).to_stderr
      end
    end
  end
end
