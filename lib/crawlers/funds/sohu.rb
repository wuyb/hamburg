require 'nokogiri'
require 'open-uri'

module Crawler
  module Fund
    SohuFundURL = 'http://q.fund.sohu.com/jzhb/kfs_rate_all_down.shtml'
    class SohuFundCrawler < FundCrawler
      def crawl
        doc = Nokogiri::HTML(open(SohuFundURL), SohuFundURL)
        doc.css('#table_body tr').each do |fund|

          f = Fund.new
          # here we can only get the basic information
          f.code = fund.css('.e1 a').first.content
          f.name = fund.css('.e2 a').first.content
          f.unit_value = fund.css('.e3').first.content.to_f
          f.unit_value_total = fund.css('.e4').first.content.to_f
          f.increment_rate = fund.css('.e5').first.content.to_f

          # retrieve more information from the detail page
          detail_url = 'http://q.fund.sohu.com/q/bc.php?code=' + f.code

          detailDoc = Nokogiri::HTML(open(detail_url), detail_url)
          f.managers = detailDoc.xpath('//div/div/div/div/table/tr[2]/td[6]').first.content
          f.company = detailDoc.xpath('//div/div/div/div/table/tr[3]/td[2]/a').first.content

          if f.save!
            p 'saved ' + f.name + ' (' + f.code + ') '
          end
          sleep(0.5)
        end
      end
    end
  end
end