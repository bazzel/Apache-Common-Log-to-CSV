## Introduction

This was a quick Ruby script to help our product owner open our Apache Common Log files.

## Requirements

This code has been run and tested manually on Ruby 2.

### Standard Library Deps

* ApacheLogRegEx

## Installation

He, it's Ruby...

    bundle install

## More Information

This [script(https://github.com/shedd/Apache-Common-Log-to-CSV) is used as a starting point for this version.

An as alternative you can webalizer:

    brew install webalizer
    brew install mergelog
    tar -xvf production_logs.tar
    cd var/log/apache2
    gunzip *.gz
    mergelog other_vhosts_access.log.* | webalizer
    open index.html

## Example Usage

Put all Apache Log files in a folder. Both uncompressed (log, log.1, log.2, etc.) and compressed (.gz) are allowed.

    INPUT_PATH=/path/to/folder/with/log/files ruby ./convert_standard_log_to_csv.rb

For every log file a CSV version is created in `/path/to/folder/with/log/files`.

## License

This project is licensed under the MIT license, a copy of which can be found in the LICENSE file.
