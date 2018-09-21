![header image](images/lencli_logo.png)
# Lencli

A marvelous command line utility that performs wonders!
Recursively search a directory and scrape gps data from images.

## Installation

bundle install

## Usage

### To run command line utility:
bundle exec bin/lencli

With no arguments the short help descriptions are printed:
```ruby
Commands:
  lencli gps_grab [SEARCH_PATH]  # Extract gps coordinates from image files.
  lencli help [COMMAND]          # Describe available commands or one specifi...
  lencli version                 # Display command-line version number.
  ```

bundle exec bin/lencli help gps_grab

Specifying a command name with help will display the long description version:
```ruby
Usage:
  lencli gps_grab [SEARCH_PATH]

Options:
  --of, [--output-format=OUTPUT_FORMAT]            
                                                   # Default: csv
                                                   # Possible values: csv, html
  --op, [--output-path=OUTPUT_PATH]                
                                                   # Default: ./lencli_output
  --ft, [--file-types=FILE_TYPES]                  
                                                   # Default: jpg
  --fm, [--filter-missing], [--no-filter-missing]  
                                                   # Default: false

Description:

  Recursively searches under the directory SEARCH_PATH for jpg files and 
  extracts the gps latitude and longitude from the image file if location data 
  is found. If a SEARCH_PATH is not provided, the current directory will be used 
  as the starting point for the search.

  Optional parameter --output-format=OUTPUT_FORMAT will specify whether the 
  generated results are CSV or HTML. The default value is the "csv" type.

  Optional parameter --output-path=OUTPUT_PATH will specify the destination 
  output file location. The default value is "./lencli_output".

  Optional parameter --file-types=FILE_TYPES will specify the image file 
  suffixes that will be used to search for exif data. The default value is 
  "jpg".

  Optional parameter --filter-missing or --no-filter-missing is a boolean value 
  to determine whether the returned data will filter results where there is no 
  exif data present.

  Examples:

  > $ gps_grab

  > $ gps_grab /home/my_home/search_directory

  > $ gps_grab /home/my_home/search_directory --output_format "html"

  > $ gps_grab /home/my_home/search_directory --op "/home/me/img.csv"
```

### To run unit tests:
bundle exec rspec

```ruby
GPSExtractionAction.call
    a valid file list value
      returns a list of gps data
    a nil file list value
      returns an empty list of gps data
    an empty array file list value
      returns an empty list of gps data
      ..
      ..
      ..
```
