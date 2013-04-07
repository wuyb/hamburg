# encoding: utf-8
require 'active_record'
require 'json'

require_relative 'bank_product_crawler'

module Crawler
  module BankProduct

    class ICBCProductCrawler < BankProductCrawler

      def initialize
        super('http://www.cmbchina.com/cfweb/svrajax/product.ashx?op=search&type=s&pagesize=999999999&pageindex=1', '招商银行')
        @bank = Bank.find_by_name @name
      end

      def parse_products (response)
        JSON.parse(response.body[1..(response.body.length-2)].gsub(/([\w]+):/, '"\1":'))["list"]
      end

      def convert p
          bp = ::BankProduct.find_by_code(p["PrdCode"])
          bp = ::BankProduct.new if bp.nil?

          bp.bank     = @bank

          bp.name     = p["PrdName"]
          bp.area     = p["AreaCode"]
          bp.can_buy  = p["IsCanBuy"] === "true"
          bp.code     = p["PrdCode"]
          bp.currency = p["Currency"]
          bp.end_date = p["EndDate"]
          bp.fin_date = p["FinDate"]
          bp.risk     = p["Risk"]
          bp.status   = p["Status"]
          bp.term     = p["Term"]
          bp.style    = p["Style"]
          bp.type_code        = p["TypeCode"]
          bp.start_date       = p["BeginDate"]
          bp.expiration_date  = p["ExpireDate"]
          bp.incr_investment  = p["IncresingMoney"]
          bp.init_investment  = p["InitMoney"]
          bp.net_value        = p["NetValue"]
          return bp
      end

    end
  end
end