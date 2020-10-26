# encoding: utf-8
namespace :hol do
  task :schedules => :environment do
    Schedule.get_schedules
    Schedule.delete_schedules
  end
end