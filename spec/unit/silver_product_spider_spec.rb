require 'kimurai'
require '/Users/dorin.pleava/Documents/Things/silver_scraper/app/models/silver_product_spider'
require 'nokogiri'
require 'open-uri'
require 'pry-byebug'

context 'silver_crawler' do
  def parse(response, url:, data: {})
    the_objects = []

    date_parsed = Time.now.strftime('%d of %B, %Y')

    response.xpath("//div[@class='petitBlocProduit']").each do |silver_product|
      item = {}
      title = silver_product.css('span')[1].children[5].children[1].children[0].text
      total_price = silver_product.css('span.prixProduit').text
      pieces = title.match(/(?<=\s)?x\d{1,}/).to_s.delete_prefix('x')

      # default to 1 if only one piece
      pieces = 1 if pieces == '' || pieces.nil?
      ounce_per_piece = title.match(%r{\d*(/)?(\d)?(?=\soz)}).to_s

      # ounce_per_piece = '1' if ounce_per_piece == ''
      price_per_piece = total_price.to_f / pieces.to_i

      price_per_oz = if ounce_per_piece.include?('/')
                       ounce_per_piece.split('/').last.to_i * price_per_piece
                     elsif ounce_per_piece == ''
                       ''
                     else
                       total_price.to_f / pieces.to_i / ounce_per_piece.to_f
                     end

      item[:title] = title
      item[:date_parsed] = date_parsed
      # item[:in_stock] = silver_product.css('span.prixProduit').text
      item[:total_price] = total_price
      item[:price_per_oz] = price_per_oz
      item[:pieces] = pieces

      # for testing
      the_objects << OpenStruct.new(item)
    end
    # for test
    the_objects
  end

  it 'parses' do
    page = Nokogiri::HTML(open('https://www.acheter-or-argent.fr/?fond=rubrique&id_rubrique=4&page=3&nouveaute=&promo='))
    asd = parse(page, url: 'test')

    puts asd.inspect

    # binding.pry
  end
end
