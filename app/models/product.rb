class Product < ActiveRecord::Base
  belongs_to  :category
  has_many  :line_items

  validates :product_name, :category_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0 }
  validates :thumburl, format:{ with: URI::regexp( %w(http https) )}

  def add_item(product_id)
    item = items.where('product_id = ?', product_id).first
    if item
      # increase the quantity of product in cart
      item.quantity + 1
      save
    else
      # product does not exist in cart
      cart.items << Item.new(product_id: product_id, quantity: 1)
    end
    save
  end

  def add_new_item(current_user, qty)
    # order ||= Order.create(user_id: current_user.id)
    order =  Order.find_by(user_id: current_user.id, status: 'cart')
    if order
      LineItem.create(order_id: Order.find_by(user_id: current_user.id).id , product_id: id, qty: qty , tax: tax_rate)
      return order
    else
      Order.create( billing_address: "BEML", shipping_address: "BTM", user_id: current_user.id)
      add_new_item(current_user, qty)
    end
  end
  
  def authorize (credit_card)
    if credit_card[:card_number] != ""
      self.status = 'payment_complete'
      self.save
      msg = "Card Details\n Number: " + credit_card[:card_number] +"\n Expairy Date: " + credit_card[:expiry_date] + "\nCVV: " + credit_card[:cvv]
    else
      "All fields are requaired!"
    end
  end
end
