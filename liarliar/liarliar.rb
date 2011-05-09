#!/usr/bin/ruby

class LiarliarSolver

	def initialize filename
		@filename = filename
		@accusations = Hash.new
		@graph = Hash.new
	end

	def solve
		reset_counters
		parse_input
		first_accuser = seed_graph
		fill_graph first_accuser
	end

	def reset_counters
		@group1 = 0
		@group2 = 0
	end

	def build_graph
		@accusations.each do |accuser, accusees|
			@graph[accuser] = :group1
			@group1 += 1
			@accusations.delete accuser

			return accuser
		end
	end

	def fill_graph accuser
		if !@graph.has_key? accuser
			return
		end

		accusees = @graph[accuser]
		accusees.each do |accusee|
			link accuser, accusee
		end

		accusees.each do |accusee|
			fill_graph accusee
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
solution = solver.solve
solver.print_accusations
