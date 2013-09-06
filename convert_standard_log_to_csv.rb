require 'csv'
require 'pathname'
require 'apachelogregex'

# find all of the files in the directory
# TODO: Update this path if if needed.
file_dir = '/Users/patrick/Downloads/var/log/apache2/'

`gunzip #{file_dir}*.gz`
log_files = Pathname.new(file_dir).children.select { |c| "#{c.basename}".match('log(\.\d+)?$') }

# go through each one
log_files.each do |pathname|
  begin
    # handle line endings
    system("dos2unix #{pathname}")

    csv_filename = "#{pathname}.csv"
    CSV.open(csv_filename, 'wb') do |csv|
      csv << ['Remote host','Remote logname','Remote user','Request Time','Request','Status','Bytes sent','Referer','UserAgent', 'Duration (e-6s)']

      pathname.each_line do |line|
        # Define the log file format.
        # This information is defined in you Apache log file with the LogFormat directive
        # /etc/apache2/apache2.conf
        format = '"%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\" %D"'

        # Initialize the parser
        parser = ApacheLogRegex.new(format)

        # Get the log line as a Hash
        l = parser.parse(line)
        # => {"\"%v:%p"=>"oss-production.philips.com:80", "%h"=>"80.239.228.47", "%l"=>"-", "%u"=>"-", "%t"=>"[04/Sep/2013:06:32:30 +0000]", "%r"=>"GET /assets/integration/1.0/oss-hld.js HTTP/1.1", "%>s"=>"200", "%O"=>"3720", "%{Referer}i"=>"http://www.click-licht.de/Nachttischleuchten-Nachttischlampen_s2", "%{User-Agent}i"=>"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; der GWH Frankfurt)", "%D\""=>"1164"}

        # parse that to CSV
        csv << [ l["%h"], l["%l"], l["%u"], l["%t"], l["%r"], l["%>s"], l["%b"], l["%{Referer}i"], l["%{User-Agent}i"], l["%D\""] ]
      end
    end
  rescue
    puts "[ERROR] Skipping %s, due to %s" % [pathname, $!]
    Pathname.new(csv_filename).delete
  end

end
