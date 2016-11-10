Puppet::Functions.create_function(:greenfield) do
	def greenfield()
		variable = closure_scope.lookupvar("::force_greenfield");
		begin
			hiera = call_function("lookup", "greenfield")
		rescue
			hiera = false;
		end
		retval = false;
		if variable == nil
			if hiera == nil
				retval = false
			else
				retval = hiera
			end
		else
			retval = variable
		end
		case retval
		when "true"
			retval = true
		when "false"
			retval = false
		end
		retval
	end
end
