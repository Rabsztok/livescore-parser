module LivescoreParser

  #----------------------------------------------------------------------------

  VERSION     = "0.1.0"
  SUMMARY     = "livescore parser"
  DESCRIPTION = "Downloads livescore results to XML files"

  require 'yaml'
  require 'mechanize'
  require 'nokogiri'
  require 'pry'

  require_relative 'livescore-parser/parser'  # Parsing from website
  require_relative 'livescore-parser/writer'  # Writing from ruby hash to XML

  # Initilizes Runner which controls all the magic stuff.
  #
  def self.run!(options = {})
    @@options = options
    data = Parser.new.run
    Writer.new(data, @@options[:destination]).run
  end

  private

  def self.gem_root
    File.expand_path '../..', __FILE__
  end

  def self.selected_pages
    @channels ||= YAML::load(File.open(@@options[:pages] || File.join(gem_root, 'pages.yml')))
  end
end
