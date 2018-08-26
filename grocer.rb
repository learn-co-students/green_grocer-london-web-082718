require 'pry'

def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |k, v|
      if new_cart.has_key?(k)
      new_cart[k][:count] += 1
      else
      new_cart[k] = v
     new_cart[k][:count] = 1
    end
    end
  end
  new_cart
end


def apply_coupons(cart, coupons)
  new_cart = cart.clone
  coupons.each do |coupon|
    cart.each do |item, details|
      if item == coupon[:item]
        if new_cart["#{item} W/COUPON"] == nil && new_cart[item][:count] >= coupon[:num]
          new_cart[item][:count] = cart[item][:count] - coupon[:num]
          new_cart["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item][:clearance], :count => 1}
        elsif new_cart["#{item} W/COUPON"] && new_cart[item][:count] >= coupon[:num]
          new_cart[item][:count] -= coupon[:num]
          #binding.pry
          new_cart["#{item} W/COUPON"][:count] += 1
        end
      end
    end
    if new_cart == {}
      new_cart = cart
    end
  end
  return new_cart
end

def apply_clearance(cart)
  new_cart = {}
  cart.each do |item, details|
    if cart[item][:clearance] == true
      new_cart[item] = cart[item]
      new_cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    else
      new_cart[item] = cart[item]
    end
  end
  return new_cart
end

def checkout(cart, coupons)
  new_cart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  sum = 0
  new_cart.each do |k,v| 
  sum += v[:count] * v[:price]
end
if sum > 100 
  sum*0.9.round(2)
  else
    sum.round(2)
end
end