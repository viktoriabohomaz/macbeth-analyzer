require 'open-uri'
require 'nokogiri'
require 'pry'

class MacbethAnalyzer 
  attr_reader :html_doc, :speakers, :number_of_lines

  MACBETH_FILE = 'http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml'

  def initialize
    @html_doc = Nokogiri::HTML(open(MACBETH_FILE))
    @speakers = []
    @number_of_lines = {}
  end

  def analyze
    speakers_list
    count_lines_for_speakers
    print_results
  end

  private 

  def count_lines_for_speakers
    @speakers.each do |speaker|
      lines = @html_doc.xpath("//speech//speaker[contains(text(), '#{speaker}')]").count     
      @number_of_lines[speaker] = lines
    end
  end

  def print_results
    @number_of_lines.each do |speaker, lines|
      p "#{lines} #{speaker}"
    end
  end

  def speakers_list
    @speakers = @html_doc.css("speech speaker").map(&:text).uniq!
    @speakers -= ["ALL"] 
  end 
end

analyzer = MacbethAnalyzer.new
analyzer.analyze