# encoding: utf-8
namespace :hol do
  task :schedules => :environment do
    Schedule.get_schedules
  end
end