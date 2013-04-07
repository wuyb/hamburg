#!/usr/bin/env ruby
# This command will start crawling the bank products

require '../lib/crawlers/bank_products/crawlers'

Crawler::BankProduct::CMBProductCrawler.new.start { |product| puts product }

