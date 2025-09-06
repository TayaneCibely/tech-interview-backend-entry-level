every 1.hour do
  runner "AbandonendCartJob.perform_later"
end

require 'sidekiq'
require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Abondoned Carts Cleanup',
  cron: '0 * * *', #A cada hora
  class: 'AbandonedCartsJob'
)