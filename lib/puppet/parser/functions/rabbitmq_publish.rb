module Puppet::Parser::Functions
	newfunction(:rabbitmq_publish, :type => :rvalue) do |args|
		retval = ""
		begin
			if defined? JRUBY_VERSION
				require "march_hare"
				$amqp_mode = "march_hare"
			else
				require "bunny"
				$amqp_mode = "bunny"
			end
			data = args[0]
			
				
			array = [];
			if data.is_a? Array
				array = data;
			else
				array << data;
			end
			routing_key = args[1]
			exchange = args[2]
			server = args[3]
			port = args[4]
			username = args[5]
			password = args[6]
			vhost = args[7]
			case $amqp_mode
			when "bunny"
				conn = Bunny.new("amqp://#{username}:#{password}@#{server}:#{port}", :vhost => vhost, :automatic_recovery => false, :recover_from_connection_close => false);
			when "march_hare"
				conn = MarchHare.connect(:uri => "amqp://#{username}:#{password}@#{server}:#{port}", :vhost => vhost, :automatic_recovery => false, :recover_from_connection_close => false);
			end
			conn.start;
			ch = conn.create_channel;
			x =	ch.topic(exchange, :durable => true);
			array.each do |shash|
				x.publish(shash.to_json, :routing_key => routing_key, :expiration => 10800000)
			end
		rescue Exception => ex
			retval = "#{ex.message}"
		ensure
			unless conn == nil
				conn.close
			end
			conn = nil
		end
		retval;
	end
end