#!/usr/bin/ruby

class LiarliarSolver

	GROUP1 = 3
	GROUP2 = 4

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
		group2_count = 0
		@graph.each do |person, group|
			if group == GROUP1
				group1_count += 1
			elsif group == GROUP2
				group2_count += 1
			else
				throw 'unexpected'
			end
		end

		counts = [group1_count, group2_count]
		counts = counts.sort
		counts = counts.reverse

		@solution = counts
	end

	def seed_graph
		g = @graph
		@accusations.each_key do |accusation|
			g[accusation[0]] = GROUP1
			g[accusation[1]] = GROUP2
			@accusations.delete accusation
			return
		end
	end

	def link_accuser accuser, accusee
		g = @graph

		if !g.has_key? accuser
			if !g.has_key? accusee
				return false
			else
				temp = accusee
				accusee = accuser
				accuser = temp
			end
		end

		if g[accuser] == GROUP1
			g[accusee] = GROUP2
		elsif g[accuser] == GROUP2
			g[accusee] = GROUP1
		else
			raise 'unexpected'
		end

		true
	end

	def build_accusationgraph
		seed_graph

		while !@accusations.empty? do
			g = @graph
			@accusations.each_key do |accusation|
				accuser = accusation[0]
				accusee = accusation[1]

				success = link_accuser accuser, accusee

				if success
					@accusations.delete accusation
				end
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
			accusee = file.gets.split[0]
			accusation = [accuser, accusee]
			@accusations[accusation] = 1
		end
	end


end

solver = LiarliarSolver.new ARGV[0]
solution = solver.solve
