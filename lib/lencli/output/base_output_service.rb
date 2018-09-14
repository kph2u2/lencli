module LenCLI
  class BaseOutputService
		def initialize(output_format, gps_list)
			@gps_list = gps_list
			@output_format = output_format
		end	
	end
end
