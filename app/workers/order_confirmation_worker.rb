class OrderConfirmationWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 5

  def perform(order_id)
    order = Order.find(order_id)
    OrderMailer.send_confirmation(order).deliver_now
  end
end
