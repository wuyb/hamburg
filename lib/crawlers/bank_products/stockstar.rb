require 'json'
require 'net/http'
require 'active_record'
require 'nokogiri'
require 'open-uri'

require_relative '../../../app/models/bank'
require_relative '../../../app/models/bank_product'

module Crawler
  module BankProducts

    class StockStarBankProductCrawler

      @@bank_products_list_url = 'http://bank.stockstar.com/bank/RmbAsset.aspx?pageid='
      @@bank_products_detail_base_url = 'http://bank.stockstar.com/bank/'

      def start
        i = 1
        while true
          doc = Nokogiri::HTML(open(@@bank_products_list_url + i.to_s))

          # get out of the loop if this is the last page
          break if doc.css('.adlist tr').length == 1

          doc.css('.adlist tr').each_with_index do |product_tr, index|

            next if index == 0  # skip the header

            # use the name to check whether it is already downloaded
            name    = doc.css('.adlist tr')[index].css('td')[1].content.strip
            product = BankProduct.find_by_name name

            # if this is a new product
            if product.nil?
              # get the detail link and use it to get more information
              link  = @@bank_products_detail_base_url + doc.css('.adlist tr')[index].css('td a')[0]['href']
              detail_doc  = Nokogiri::HTML(open(link), nil, 'gb2312')
              detail_doc.encoding = 'gb2312'
              tables  = detail_doc.css('table')
              tables.each do |table|
                if table.css('tr.bank2008-listpage1-title').length > 0
                  product = BankProduct.new
                  product.name = name

                  bank_name    = table.xpath('.//tr')[1].css('td')[1].content.strip    # bank name
                  product.bank = Bank.find_by_name bank_name
                  product.bank = Bank.new(:name => bank_name) if product.bank.nil?
                  product.bank.save if product.bank.new_record?

                  product.area        = table.xpath('.//tr')[3].css('td')[1].content.strip    # area name
                  product.start_date  = table.xpath('.//tr')[4].css('td')[1].content.strip    # sales start date
                  product.end_date    = table.xpath('.//tr')[5].css('td')[1].content.strip    # sales end date
                  product.fin_date    = table.xpath('.//tr')[6].css('td')[1].content.strip    # interests calculation start date
                  product.term        = table.xpath('.//tr')[7].css('td')[1].content.strip    # management terms (number of days)
                  product.yearly_interest = table.xpath('.//tr')[9].css('td')[1].content.strip    # yearly interest
                  product.interest_notes  = table.xpath('.//tr')[10].css('td')[1].content.strip    # interest notes
                  product.currency    = table.xpath('.//tr')[11].css('td')[1].content.strip    # currency
                  product.init_investment = table.xpath('.//tr')[12].css('td')[1].content.strip    # initial investment
                  product.incr_investment = table.xpath('.//tr')[13].css('td')[1].content.strip    # increment investment
                  product.end_conditions  = table.xpath('.//tr')[14].css('td')[1].content.strip    # end conditions

                  # sometimes nokogiri can't recognize all 19 rows -_-!
                  if table.xpath('.//tr').length > 16
                    product.management_fee  = table.xpath('.//tr')[16].css('td')[1].content.strip    # management fee
                    product.special_notes   = table.xpath('.//tr')[17].css('td')[1].content.strip    # special notes for this product
                    product.special_sales   = table.xpath('.//tr')[18].css('td')[1].content.strip    # special sales
                  else
                    puts "Bad : #{name}"
                  end

                  puts "#{product.name} - #{product.bank.name} - #{product.area} - #{product.start_date} - #{product.end_date}"
                  puts "#{product.fin_date} - #{product.term} - #{product.yearly_interest} - #{product.interest_notes} - #{product.currency}"
                  puts "#{product.init_investment} - #{product.incr_investment} - #{product.end_conditions} - #{product.management_fee}"
                  puts "#{product.special_notes} - #{product.special_sales}"

                  product.save
                  # sleep in case it gets blocked
                  sleep(2 + rand(5))
                  break
                end # done - if this is the table we care
              end # done - iterate the tables
            end # done - if product.nil?
          end # done - each product

          i = i + 1

          # sleep in case it gets blocked
          sleep(2 + rand(10))
        end
      end

      protected


    end
  end
end