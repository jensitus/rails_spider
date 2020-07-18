# encoding: utf-8
namespace :hol do
	task :movies => :environment do
		Movie.fetch_movies
	end
end
