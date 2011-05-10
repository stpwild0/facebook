#!/usr/bin/ruby

class LiarliarSolver

	def initialize filename
		@filename = filename
		@accusations = Hash.new
		@graph = Hash.new
		@accuser_queue = Array.new
	end

	def solve
		reset_counters
		parse_input
		seed_graph
		fill_graph

		result_string
	end

	def result_string
		result = [@group1, @group2]
		result.sort!
		result.reverse!

		"%d %d" % [result[0], result[1]]
	end

	def reset_counters
		@group1 = 0
		@group2 = 0
	end

	def seed_graph
		@accusations.each do |accuser, accusees|
			@graph[accuser] = :group1
			@group1 += 1
			@accuser_queue.push accuser
			return
		end
	end

	def fill_graph
		@accuser_queue.each do |accuser|
			if !@accusations.has_key? accuser
				next
			end

			accusees = @accusations[accuser]
			accusees.each do |accusee|
				link accuser, accusee
			end

			@accusations.delete accuser
			
			accusees.each do |accusee|
				@accuser_queue.push accusee
			end
		end
	end

	def link accuser, accusee
		if @graph.has_key? accusee
			return
		end

		accuser_group = @graph[accuser]
		if accuser_group == :group1
			@graph[accusee] = :group2
			@group1 += 1
		else
			@graph[accusee] = :group1
			@group2 += 1
		end
	end

	def print_accusations
		@accusations.each do |accuser, accusees|
			puts accuser
			accusees.each do |accusee|
				puts '  ' + accusee
			end
		end
	end

	def parse_input
		file = File.new @filename, 'r'

		num_accusers = file.gets 
		num_accusers = num_accusers.to_i

		num_accusers.times do
			parse_accuser file
		end

	end

	def parse_accuser file
		accuser_info = file.gets.split
		accuser = accuser_info[0]
		num_accusations = accuser_info[1].to_i

		num_accusations.times do
			accusee = file.gets.split[0]
			add_accusation accuser, accusee
			add_accusation accusee, accuser
		end
	end

	def add_accusation accuser, accusee
		if !@accusations.has_key? accuser
			@accusations[accuser] = Array.new
		end

		@accusations[accuser].push accusee
	end


end

solver = LiarliarSolver.new ARGV[0]
puts solver.solve
