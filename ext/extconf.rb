require 'mkmf'

unless have_header('mpg123.h')
  puts "please install mpg123"
  exit
end

unless have_library('mpg123')
  puts "please install mpg123"
  exit
end

create_makefile('mpg123')
