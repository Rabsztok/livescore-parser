require 'pry'

module LivescoreParser
  class Parser

    def initialize
      @agent = Mechanize.new
      @offset = Time.new.utc_offset + (5 * 3600)
      cookie = Mechanize::Cookie.new('tz', (@offset / 3600).to_s)
      cookie.path = '/'
      cookie.domain = '.www.livescore.com'
      @agent.cookie_jar.add(cookie)
    end

    # Runs dynamic-sprites command.
    #
    def run
      LivescoreParser.selected_pages.map do |name, options|
        data = download(options['url'])
        { name: name, path: options['path'], data: data } unless data.nil?
      end.compact
    end

    private

    def download(url)
      page = Nokogiri::HTML(@agent.get(url).body)
      data = build_hash page.css(".content > *")
      if data.empty?
        puts "Missing data"
        return nil
      else
        return data
      end
    end

    # convert nokogiri html data to handy hash structure
    def build_hash(data)
      index = 0
      data.map do |row|
        if row.attr('class').match 'row-gray'
          index += 1
          time_raw = row.css('.min').text.strip
          local_time = Time.parse(time_raw) + Time.new.utc_offset - @offset rescue Time.now
          local_date = local_time.hour >= 19 ? @date.clone - 1 : @date.clone
          {
            wiersz: index,
            czas: (time_raw.match(/[0-9]+:[0-9]+/)) ? local_time.strftime('%H:%M') : time_raw,
            gracz1: row.css('.ply.tright').text.strip,
            wynik1: row.css('.sco').text.strip.match(/^[0-9\?]+/).to_s,
            gracz2: row.css('.sco + .ply').text.strip,
            wynik2: row.css('.sco').text.strip.match(/[0-9\?]+$/).to_s,
            data: local_date.strftime('%B %d'),
            kraj: @country.clone,
            liga: @league.clone
          }
        elsif row.attr('class').match 'row-tall'
          @country = row.css('.left a:first').text.strip
          @league = row.css('.left a:last').text.strip
          @date = Date.parse(row.css('.right').text.strip)
          next
        end
      end.compact
    end
  end
end
