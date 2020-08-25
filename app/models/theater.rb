class Theater < ApplicationRecord

  # t.string "_ID"
  # t.string "name"
  # t.string "typename"
  # t.string "address"
  # t.string "telephone"
  # t.string "url"
  # t.datetime "created_at", precision: 6, null: false
  # t.datetime "updated_at", precision: 6, null: false

	validates :_ID, presence: true
	validates :_ID, uniqueness: true

  HEADERS_HASH = { 'User-Agent' => 'lets crawl'}

  def self.get_theaters
    da = Date.today
    date = da.upto( da + 7  )
    date.each do |d|
      response_zum_donner = RestClient::Request.new(
        :method => :get,
        :url => "https://efs.skip.at/api/v1/cfs/filmat/screenings/nested/cinema/#{d}"
      ).execute
      results = JSON.parse(response_zum_donner.to_str)
      results["result"].each do |r|
        puts r.inspect
        if r["parent"]["type"] == "cinema"
          
          url = "https://www.skip.at/kino/" + r["parent"]["uri"].split('/')[3]

          page = Nokogiri::HTML(open(url, HEADERS_HASH))
          address = page.xpath('//div[@class="theater-header"]/div/div/div[1]/p/span[2]').text
          tel = page.xpath('//div[@class="theater-header"]/div/div/div[2]/p/a').text.gsub('-', ' ')
          web = page.xpath('//div[@class="theater-header"]/div/div/div[3]/p/a').text

          if r["parent"]["county"] == "Wien"
            name = r["parent"]["title"]
            _ID = "c-" + r["parent"]["title"].downcase.gsub(/\s/, '-').gsub('ä', 'ae').gsub('ö', 'oe').gsub('ü', 'ue').gsub('ñ', 'n').gsub('ß', 'ss').gsub('---', '-').delete("?!'.")
            
            @theater = Theater.new(
            name: name, 
            _ID: _ID,
            typename: "theater",
            telephone: tel,
            address: address,
            url: web,
            skip_id: r["parent"]["id"]
            )

            t = Theater.find_by(_ID: _ID)

            if t.nil?
              if @theater.save
                puts 'hell yeah'
              else
                puts 'shit hell'
              end
            end
          end
          puts name
          puts _ID

          sleep 2
        end
      end
    end
  end

  def self.get_all
    Theater.all
  end

end
