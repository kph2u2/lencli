module LenCLI
  class BaseOutputService
    def initialize(action, output_path=nil)
      @action = action
      @output_path = output_path
    end 
  end
end
