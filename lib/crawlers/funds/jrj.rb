require 'nokogiri'
require 'open-uri'

module Crawler
  module Fund
    JRJFundURL = 'http://fund.jrj.com.cn/funddata/family1.shtml'
    class JRJFundCrawler < FundCrawler
      def crawl
        doc = Nokogiri::HTML(open(JRJFundURL), JRJFundURL)
        doc.css('#con_box_1 .box td a').each do |fund|
          code_and_name = fund.content.gsub(/[】【]/, ' ').split

          p 'start retrieving information for ' + fund.content

          f = Fund.find_by_code(code_and_name[0])
          if !f
            f = Fund.new
            f.code = code_and_name[0]
          end
          f.name = code_and_name[1]

          detail_url = "http://fund.jrj.com.cn/archives,#{f.code},jjjz.shtml"
          detail_doc = Nokogiri::HTML(open(detail_url), detail_url)

          p 'getting unit value and accumulated unit value...'

          header = detail_doc.css('div.tbcont table tr').first
          if !header
            next
          end

          # unit value and accumulated unit value
          values = header.next
          if values.css('td').length > 1
            f.unit_value = values.css('td')[1].content
            f.unit_value_total = values.css('td')[2].content
          end

          p 'getting company and managers...' + header.css('th')[1].content
          # company and managers
          if header.css('th')[1].content == '万份收益（元）'
            f.company = detail_doc.css('div.minfo .data tr').first.next.css('td a')[1].content
          elsif header.css('th')[1].content == '单位净值（元）'
            # ignore closed fund and others
            if detail_doc.css('div.minfo .data tr').first.next.next.css('td a').first
              f.company = detail_doc.css('div.minfo .data tr').first.next.next.css('td a').first.content
            end
          end
          if detail_doc.css('div.minfo .data #fundmanager').first
            f.managers = detail_doc.css('div.minfo .data #fundmanager').first.content
          end

          p 'getting open status...'
          # open status - buyable or not
          if detail_doc.css('div.minfo .data #purchase_status').first
            p detail_doc.css('div.minfo .data #purchase_status').first.content
          else
            p 'no purchase_status'
          end

          f.open = detail_doc.css('div.minfo .data #purchase_status').first and 
            detail_doc.css('div.minfo .data #purchase_status').first.content == '开放'

          if f.save
            p 'done retrieving information for ' + f.inspect
          else
            p 'error saving :' + f.errors
          end
        end
      end
    end
  end
end