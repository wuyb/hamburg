require 'net/http'
require 'json'

module Crawler
  module Fund

    StockStarFundURL = 'http://canal.stockstar.com/base/V_JRJ_FUND_NET_LASTDAY/vname=latelyFunds&limit=9999&field=FUND_CODE,INVST_TYPE,UNIT_NET,UNIT_NET_CHNG_PCT,FUNDSNAME,TENTHOU_UNIT_INCM,YEAR_YLD,PURCHASE_STATUS,REDEMPTION_STAUS,FUNDMANAGER,UNIT_NET_CHNG_1,ACCUM_NET,MANA_NAME'

    class StockStarFundCrawler < FundCrawler
      def crawl
        url = URI.parse(StockStarFundURL)
        full_path = (url.query.blank?) ? url.path : "#{url.path}?#{url.query}"
        the_request = Net::HTTP::Get.new(full_path)

        the_response = Net::HTTP.start(url.host, url.port) { |http|
          http.request(the_request)
        }

        raise "Response was not 200, response was #{the_response.code}" if the_response.code != "200"

        funds = JSON.parse(the_response.body.gsub('var latelyFunds=', '').gsub(';', ''))

        funds.each do |f|
          fund = Fund.find_by_code f["FUND_CODE"]
          if !fund
            fund = Fund.new
            fund.code = f["FUND_CODE"]
          end

          fund.name = f["FUNDSNAME"].encode('utf-8', 'gbk')
          fund.managers = f["FUNDMANAGER"].encode('utf-8', 'gbk') if f["FUNDMANAGER"]
          fund.unit_value = f["UNIT_NET"].to_f
          fund.unit_value_total = f["ACCUM_NET"].to_f
          fund.company = f["MANA_NAME"].encode('utf-8', 'gbk') if f["MANA_NAME"]
          fund.open = f["PURCHASE_STATUS"].to_i == 1
          fund.increment_value = f["UNIT_NET_CHNG_1"].to_f
          fund.increment_rate = f["UNIT_NET_CHNG_PCT"].to_f

          fund.save
        end
      end
    end
  end
end