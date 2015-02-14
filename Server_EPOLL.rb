#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'

HOST = 'localhost'
PORT = 8005


module EchoServer
	$i = 0
  $messageCount = 0
   	
   	#Occurs when clients connect
   	def post_init
    	puts $i += 1
   	end

   	#Occurs when receiving data
  	def receive_data(data)
      send_data ("E_#{data}")
      puts ("#{data.chomp} -> #{$messageCount += 1}")
  	end

  	#Occurs when client disconnects
  	def unbind
    	puts $i -= 1
   	end

end #end module Echo

#
EM.epoll

#-------------------------------------------------------------
# Increase the number of file descriptors
#-------------------------------------------------------------
begin
	new_size = EM.set_descriptor_table_size( 10000 )
rescue Exception => e
	puts "Exception:: " + e.message + "\n"
	puts "> Unable to set total file descriptors"
end

#puts EM.set_descriptor_table_size
#-------------------------------------------------------------

begin

  EM.run { 
    puts "Echo server listening on #{HOST}:#{PORT}"
    EM.start_server HOST, PORT, EchoServer
  }

rescue Exception => e
  puts e.message
  puts "Server Failure"
end