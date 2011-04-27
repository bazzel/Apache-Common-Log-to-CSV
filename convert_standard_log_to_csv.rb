require 'rubygems'
require 'csv'
require 'apachelogregex'

# Requires the following gem:
# gem install apachelogregex

# find all of the files in the directory
#directory = File.join( File.dirname(__FILE__), 'Access Log')
file_dir = "./CLF/"
files = Dir.new(file_dir).entries
files.delete(".")
files.delete("..")
files.delete(".DS_Store")

# go through each one
files.each do |filename|
  filename = file_dir + filename
  
  # handle line endings
  system("dos2unix #{filename}")
  
  #prep the output file
  outfile = File.open(filename + ".csv", 'a')
  
  # write headers
  csv = []
  CSV::Writer.generate(outfile) do |csv|
    csv << ['Client IP','IdentityCheck','HTTPAuthUser','RequestFinishedAt','Request','Status','Size','Referer','UserAgent']
  end
  
  # read the file in line by line
  file = File.new(filename, "r")
  while (line = file.gets)
    # write row to the csv file
    csv = []
    CSV::Writer.generate(outfile) do |csv|
      # parse the Apache Common Log Format
      
      # Define the log file format.
      # This information is defined in you Apache log file with the LogFormat directive
      format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'

      # Initialize the parser
      parser = ApacheLogRegex.new(format)

      # Get the log line as a Hash
      l = parser.parse(line)
      # => {"%r"=>"GET /blog/index.xml HTTP/1.1", "%h"=>"87.18.183.252", "%>s"=>"302", "%t"=>"[13/Aug/2008:00:50:49 -0700]", "%{User-Agent}i"=>"Feedreader 3.13 (Powered by Newsbrain)", "%u"=>"-", "%{Referer}i"=>"-", "%b"=>"527", "%l"=>"-"}
      
      # parse that to CSV
      csv << [ l["%h"], l["%l"], l["%u"], l["%t"], l["%r"], l["%>s"], l["%b"], l["%{Referer}i"], l["%{User-Agent}i"] ]
    end
  end
  
  file.close
  outfile.close
end
