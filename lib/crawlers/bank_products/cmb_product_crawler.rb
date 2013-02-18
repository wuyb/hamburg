require 'net/http'
require 'json'

module Crawler
  module BankProduct

    CMBProductURL = 'http://www.cmbchina.com/CFWEB/svrajax/product.ashx?op=search&type=s&pagesize=999999999&pageindex=1'

    class CMBProductCrawler < BankProductCrawler
      def crawl
        url = URI.parse(CMBProductURL)
        full_path = (url.query.blank?) ? url.path : "#{url.path}?#{url.query}"
        the_request = Net::HTTP::Get.new(full_path)

        the_response = Net::HTTP.start(url.host, url.port) { |http|
          http.request(the_request)
        }

        raise "Response was not 200, response was #{the_response.code}" if the_response.code != "200"

        products = JSON.parse(the_response.body[1..(the_response.body.length-2)].gsub(/([\w]+):/, '"\1":'))["list"]

        bank = Bank.find_by_name("招商银行")
        products.each do |p|
          bp = BankProduct.find_by_code(p["PrdCode"])
          bp = BankProduct.new if bp.nil?
          bp.bank = bank

          bp.area = p["area_code"]
          bp.can_buy = p["IsCanBuy"] === "true"
          bp.code = p["PrdCode"]
          bp.currency = p["currency"]
          bp.end_date = 
        end
      end
    end
  end
end