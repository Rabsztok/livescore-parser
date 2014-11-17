require 'builder'
require_relative 'hash_helper'

module LivescoreParser
  class Writer

    def initialize(scores, destination)
      @scores = scores
      @destination = destination
    end

    def run
      @scores.each do |page|
        File.open(xml_path(page[:name]), "w+") do |file|
          file.write(build_xml(page[:data]))
        end
      end
    end

    private

    def xml_path(name)
      File.join(@destination, "#{name}_#{Date.today.to_s}.xml")
    end

    # Builds XML data from schedule Hash
    def build_xml(data)
      xml_builder = Builder::XmlMarkup.new( :indent => 2 )
      xml_builder.instruct! :xml, :encoding => "UTF-8"
      xml_builder.xml do |xml|
        data.each do |score|
          xml.node do |node|
            node.wiersz score[:wiersz]
            node.czas score[:czas]
            node.gracz1 score[:gracz1]
            node.wynik1 score[:wynik1]
            node.gracz2 score[:gracz2]
            node.wynik2 score[:wynik2]
          end
        end
      end
    end
  end
end
# {:wiersz=&gt;1, :czas=&gt;"19:45", :gracz1=&gt;"Wycombe Wanderers", :wynik1=&gt;"?", :gracz2=&gt;"Burton Albion", :wynik2=&gt;"?"}