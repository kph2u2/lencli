require "lencli/action/gps_search_action"

module LenCLI
  describe 'GpsSearchAction' do
    describe '.gps_data_from_files' do
      before do
        allow(MiniMagick::Image)
          .to receive(:open).and_return(image_object)
        allow(File)
          .to receive(:basename).and_return("image_file_1", "image_file_2")
        allow(image_object)
          .to receive(:exif).and_return(*image_metadata)
      end
      let(:image_metadata) do
        [
          { "GPSLatitude" => "38,24,0N", "GPSLongitude" => "10,41.735887E" },
          { "GPSLatitude" => "50,11,5N", "GPSLongitude" => "05,99.8734892E" },
        ]
      end
      let(:image_object) { double("MiniMagick::Image") } 
      let(:file_list) { ["/home/image_file_1", "/home/image_file_2"] } 
      let(:gps_search_action) { GPSSearchAction.new(file_list) }
      let(:subject) { gps_search_action.gps_data_from_files }

      context 'a valid file list value' do
        let(:expected_gps_data) do
          [
            ["image_file_1", "38,24,0N", "05,99.8734892E"],
            ["image_file_2", "50,11,5N", "05,99.8734892E"],
          ]
        end

        it 'returns a list of gps data' do
          is_expected.to eq(expected_gps_data)
        end
      end

      context 'a nil file list value' do
        let(:file_list) { nil } 
        
        it 'returns an empty list of gps data' do
          is_expected.to eq([])
        end
      end

      context 'an empty array file list value' do
        let(:file_list) { [] } 
        
        it 'returns an empty list of gps data' do
          is_expected.to eq([])
        end
      end

      context 'user lacks permissions' do
        before do
          allow(MiniMagick::Image).to receive(:open).and_raise(Errno::EACCES)
          allow($stderr).to receive(:write)
        end
        
        it 'returns an empty list of gps data' do
          is_expected.to eq([])
        end

        it 'outputs a warning message to standard error' do
          expect { subject }.to output(/Missing required permissions/).to_stderr
        end
      end

      context 'invalid image file contents' do
        before do
          allow(MiniMagick::Image)
            .to receive(:open).and_raise(MiniMagick::Invalid)
          allow($stderr).to receive(:write)
        end
        
        it 'returns an empty list of gps data' do
          is_expected.to eq([])
        end

        it 'outputs a warning message to standard error' do
          expect { subject }.to output(/is not a valid image file/).to_stderr
        end
      end
    end
  end
end
