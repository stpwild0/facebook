#!/usr/bin/ruby

class LiarliarSolver

	class Accusation
		attr_reader :accuser, :accusee

		def initialize accuser, accusee
			@accuser = accuser
			@accusee = accusee
		end

		def to_s
			"'%s' '%s'" % [accuser, accusee]
		end
	end


	def initialize filename
		@filename = filename
		@accusations = Hash.new
		@graph = Hash.new
	end

	def solve
		parse_input
		build_accusationgraph
		count_groups
		print_solution
	end

	def print_solution
		puts "%d %d" % [@solution[0], @solution[1]]
	end

	def count_groups
		group1_count = 0
		@graph.each do |person, group|
			if group == 3
				group1_count += 1
			end
		end

		group2_count = @graph.count - group1_count
		counts = [group1_count, group2_count]
		counts.sort!.reverse!

		@solution = counts
	end

	def seed_graph
		g = @graph
		@accusations.each_key do |accusation|
			g[accusation.accuser] = 3
			g[accusation.accusee] = 4
			@accusations.delete accusation
			return
		end
	end

	def build_accusationgraph
		seed_graph

		while !@accusations.empty? do
			g = @graph
			@accusations.each_key do |accusation|
				accuser = accusation.accuser
				accusee = accusation.accusee
				if !g.has_key? accuser
					if !g.has_key? accusee
						next
					elsif g[accusee] == 3
						g[accuser] = 4
					elsif g[accusee] == 4
						g[accuser] = 3
					end
				elsif g[accuser] == 4
					g[accusee] = 3
				elsif g[accuser] == 3
					g[accusee] = 4
				else
					throw 'unexpected'
				end

				@accusations.delete accusation
			end
		end
	end

	def print_accusations
		@accusations.each_key do |accusation|
			puts accusation.to_s
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
			accusee = file.gets.rstrip!
			accusation = Accusation.new accuser, accusee
			@accusations[accusation] = nil
		end
	end


end

solver = LiarliarSolver.new ARGV[0]
solution = solver.solve
