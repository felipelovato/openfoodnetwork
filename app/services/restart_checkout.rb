# Resets the passed order to cart state while clearing associated payments and shipments
class RestartCheckout
  def initialize(order)
    @order = order
  end

  def call
    return if order.cart?

    reset_state_to_cart
    clear_shipments
    clear_payments

    order.reload
  end

  private

  attr_reader :order

  def reset_state_to_cart
    order.restart_checkout!
  end

  def clear_shipments
    order.update_attributes!(shipping_method_id: nil)
    order.shipments.with_state(:pending).destroy_all
  end

  def clear_payments
    order.payments.with_state(:checkout).destroy_all
  end
end
