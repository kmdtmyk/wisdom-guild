# frozen_string_literal: true

require 'nokogiri'

module MtgScraper
  module Hareruya
    module List
      class V2
        include Enumerable

        def initialize(html)
          @html = html
        end

        def each
          nodes.each do |node|
            yield parse_node(node)
          end
        end

        def size
          item_nodes.size
        end

        def [](nth)
          item_nodes = doc.css('.itemListLine.itemListLine--searched li')
          parse_node(item_nodes[nth])
        end

        def parse_node(node)
          item_name = node.css('.itemName').text

          %r{《([^/]+)/([^/]+)》}.match(item_name)
          name = Regexp.last_match(1)
          english_name = Regexp.last_match(2)

          if item_name.match? %r{【EN】}
            language = 'english'
          elsif item_name.match? %r{【JP】}
            language = 'japanese'
          end

          foil = item_name.match? %r{【Foil】}

          if item_name.match %r{\[(.+)\]}
            card_set_code = Regexp.last_match(1)
          end

          basic_land = %w(平地 島 沼 山 森 荒地).include? name

          price_node = node.css('.row.not-first.ng-star-inserted')[0]
          price_text = price_node.text
          price_text.match %r{¥ ?[\d,]+}
          price = Regexp.last_match(0).gsub(/[^\d]/, '').to_i

          {
            name: name,
            english_name: english_name,
            language: language,
            price: price,
            foil: foil,
            card_set_code: card_set_code,
            basic_land: basic_land,
          }
        end

        def category_list
          doc.css('.category_menu .category_key').map do |node|
            {
              name: category_name(node),
              id: category_id(node),
            }
          end
        end

        def next_page_url
          node = doc.css('.result_pagenum')
          if node.css('.now_').empty?
            node.css('a')[0][:href]
          else
            node.css('.now_ + a')[0][:href]
          end
        rescue
          nil
        end

        def total_page
          match_data = doc.css('.result_pagenum').text.match(/([\d]+)ページ中/)
          match_data[1].to_i
        rescue
          nil
        end

        private

          def category_id(node)
            link = node.css('a[href*="cardset="]')[0]
            href = link[:href]
            match_data = href.match(/cardset=([\d]+)/)
            id = match_data[1].to_i
          rescue
            nil
          end

          def category_name(node)
            name = node.css('h5').text.strip
          rescue
            nil
          end

          def doc
            Nokogiri::HTML(@html)
          end

          def item_nodes
            doc.css('.itemListLine.itemListLine--searched li')
          end

      end
    end
  end
end