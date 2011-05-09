def sum_of_spirals_diagonals dimension_size
	target_dimension = dimension_size
	current_dimension = 3
	current_corner_value = 1
	sum = 1;
	
	while current_dimension <= target_dimension
		corners_differences = current_dimension - 1
		
		for i in (1..4)
			current_corner_value += corners_differences
			sum += current_corner_value
			#puts "%i %i" % [current_corner_value, sum]
		end
		
		#puts '%i %i' % [current_dimension, sum]
		
		current_dimension += 2
	end
	
	sum
end

puts sum_of_spirals_diagonals 111111
