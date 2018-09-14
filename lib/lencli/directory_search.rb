module LenCLI
  class DirectorySearch
    def self.find_files(search_path="./", file_types="*")
      file_types ||= "*"
      search_path ||= "./"

      Dir.glob("#{search_path}/**/*.{#{file_types}}")
    end
  end
end
