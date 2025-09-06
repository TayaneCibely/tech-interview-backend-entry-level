class AbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform
    mark_as_abandoned
    remove_old_abandoned_carts
  end

  private

  def mark_as_abandoned
    Cart.active
        .where('updated_at < ?', 3.hours.ago)
        .update_all(status: :abandoned, updated_at: Time.current)
  end

  def remove_old_abandoned_carts
    Cart.abandoned
        .where('updated_at < ?', 7.days.ago)
        .destroy_all
  end
end
