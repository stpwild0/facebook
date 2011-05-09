#!/usr/bin/ruby

class LiarliarSolver

	class Accusation
		attr_reader :accuser, :accusee

		def initialize accuser, accusee
			@accuser = accuser
			@accusee = accusee
		end

		def to_s
			"%s %s" % [accuser, accusee]
		end
	end


	def initialize filename
		@filename = filename
		@accusations = Array.new
		@graph = Hash.new
	end

	def solve
		parse_input
		build_accusationgraph
	end

	def build_accusationgraph
		g = @graph
		accusation = @accusations.pop

	end

	def print_accusations
		@accusations.each do |accusation|
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
			accusee = file.gets
			accusation = Accusation.new accuser, accusee
			@accusations.push accusation
		end
	end


end

solver = LiarliarSolver.new ARGV[0]
solution = solver.solve
