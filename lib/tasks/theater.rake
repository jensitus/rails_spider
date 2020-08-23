# encoding: utf-8
namespace :hol do
  task :theaters => :environment do
    Theater.get_theaters
  end
end
