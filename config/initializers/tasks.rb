require 'rubygems'
require 'rufus/scheduler'
require 'net/http'
require 'json'

scheduler = Rufus::Scheduler.start_new

  # pull the currencies everyday at midnight

  scheduler.cron '0 0 * * * Asia/Shanghai' do
    puts 'pulling currencies'

    # XXX currently use openexchangerates as data source, will update to BOC rates later for production
    uri   = URI('http://openexchangerates.org/api/latest.json?app_id=2dd5673aa2154ce4bd39427675b91537')
    response  = Net::HTTP.get_response(uri)
    if response.code == '200'
      json = JSON.parse(response.body)
      json['rates'].each do |code, rate|
        currency = Currency.find_by_code(code)
        if currency.nil?
          currency = Currency.new(:code=>code, :rate_to_usd=>rate.to_f)
        else
          currency.rate_to_usd = rate.to_f
        end
        currency.save
      end
    end

    puts 'currencies pulled'
end

