require 'json'
require 'net/http'

require_relative '../../../app/models/bank'
require_relative '../../../app/models/bank_product'

module Crawler
  module BankProduct

    # This class is the base class for all bank product crawlers.
    # The crawl method retrieves the content of the given #bank_products_list_url.
    # It calls the #convert method to convert the downloaded info to the #BankProduct entity
    # and store it in the persistence.
    class BankProductCrawler

      def initialize (url, name)
        @bank_products_list_url = url
        @name = name
      end

      # This method starts the crawling of bank products at the given url.
      # A block is expected to handle the parsed bank products.
      def start
        i = 0
        while true
          url       = URI.parse(@bank_products_list_url + (page_index + i))
          full_path = (url.query.blank?) ? url.path : "#{url.path}?#{url.query}"
          request   = Net::HTTP::Get.new(full_path)

          response  = Net::HTTP.start(url.host, url.port) { |http|
            http.request(request)
          }

          raise "Response was not 200, response was #{response.code}, error was #{response.body}" if response.code != "200"

          products  = parse_products response

          products.each do |p|
            yield convert p
          end

          # get out of the loop if this is the last page
          break if is_last_page response
          i = i + 1;
        end
      end

      protected

      def is_last_page response
        raise "The is_last_page method must be implemented by subclass!"
      end

      def page_index
        raise "The page_index method must be implemented by subclass!"
      end

      # This method should be implemented by subclass to parse the given bank specific format
      # of bank products.
      def parse_products (response_body)
        raise "The parse_products method must be implemented by subclass!"
      end

      # This method should be implemented by subclass to convert the given bank specific format
      # of bank products to the universal one BankProduct.
      def convert
        raise "The convert method must be implemented by subclass!"
      end

    end
  end
end