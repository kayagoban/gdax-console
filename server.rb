
require 'openssl'
require 'coinbase/exchange'
require 'eventmachine'
require 'pry'
require 'colorize'


websocket = Coinbase::Exchange::Websocket.new(product_id: 'ETH-USD',
                                              keepalive: true)
websocket.match do |resp|
  puts "match #{resp}"
  #p resp
  
# color = if resp.side == 'sell'
#            :red
#          else
#            :green
#          end

 # str = "#{'%.2f' % resp.price} -- #{'%.6f' % resp.size}"
  #puts str.send(color)
#  puts resp
end

websocket.snapshot do |resp|
  puts "Destroying #{Order.count} orders"
  Order.delete_all

  bids = resp.bids.map do |tuple|
    Order.new( side: 'bid', price: tuple.first, size: tuple.last )
  end

  Order.import bids

  asks =  resp.asks.map do |tuple|
    Order.new(side: 'ask', price: tuple.first, size: tuple.last)
  end
  
  Order.import asks

  puts "Created #{Order.count} orders"
end

websocket.update do |resp|
  binding.pry

  #Order.find_by_price resp.
end

  #p "Spot Rate: £ %.2f" % resp.price
EM.run do
  websocket.start!
=begin
  EM.add_periodic_timer(2) {
    websocket.ping do
      p "Websocket is alive"
    end
  }
  EM.error_handler { |e|
    p "Websocket Error: #{e.message}"
  }
=end
end





=begin

#Async client

rest_api = Coinbase::Exchange::AsyncClient.new(ENV['GDAX_KEY'], ENV['GDAX_SECRET'], ENV['GDAX_PHRASE'])

EM.run {
  EM.add_periodic_timer(10) {
    rest_api.last_trade(product_id: "ETH-USD") do |resp|
      p "Spot Rate: USD %.2f" % resp.price
    end
  }
}

=end










=begin

# This is synchronous client

require 'coinbase/exchange'

rest_api = Coinbase::Exchange::Client.new(api_key, api_secret, api_pass)
while true
  sleep 10
  rest_api.last_trade(product_id: "BTC-GBP") do |resp|
    p "Spot Rate: £ %.2f" % resp.price
  end
end

=end
