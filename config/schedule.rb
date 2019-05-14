# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
 job_type :runner,  "cd :path && RAILS_ENV=production /home/sed/.rbenv/shims/rails runner  ':task' :output"
 set :output, "~/rails-sinchro/log/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# every 2.hours do
#    runner  "Site.where(:name => 'horosho-gk.ru').first.compares.new(:name => 'Автоматическая').launch"
# end
every 3.hours do
   runner  "Site.where(:name => 'horosho-ufa.ru').first.compares.new(:name => 'auto').launch"
end
every 1.day, at: '1:00 am' do
     runner "Compare.where(:updated_at=>(1.year.ago..5.days.ago)).destroy_all"
end
every 1.day, at: '1:30 am' do
     runner "ActiveRecord::Base.connection.execute('VACUUM')"
end