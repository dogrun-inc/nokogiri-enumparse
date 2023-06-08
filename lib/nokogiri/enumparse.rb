# frozen_string_literal: true

require 'nokogiri'
require_relative 'enumparse/version'

module ::Nokogiri::XML
  #
  # Python の etree.iterparse と類似の機能を提供するクラス
  #
  class EnumParse
    class SAXDoc < ::Nokogiri::XML::SAX::Document
        def initialize(tag)
            @tag = tag
            @buf = StringIO.new
            @layer = 0
        end

        def start_element(name, attrs)
            @layer += 1 if name == @tag
            return if @layer == 0
            if attrs.empty?
                @buf << "<#{name}>"
            else
                attr_pairs = attrs.map do |a|
                    a[0] + '="' + a[1].gsub('"', '%22') + '"'
                end.join(' ')
                @buf << "<#{name} #{attr_pairs}>"
            end
        end

        def end_element(name)
            return if @buf.length == 0
            @layer -= 1 if name == @tag
            @buf << "</#{name}>" if @layer > 0
            if @layer == 0 && name == @tag
                @buf << "</#{name}>"
                Fiber.yield(@buf.string)
                @buf = StringIO.new
            end
        end

        def characters(string)
            @buf << CGI.escapeHTML(string) if @layer > 0
        end
    end

    #
    # コンストラクタ
    #
    # @param [String] file_path XMLファイルのパス
    # @param [String] tag XMLファイルから分割して切り出すタグ
    #
    def initialize(file_path, tag)
        raise ArgumentError, 'file_path is not set.' unless file_path.is_a?(String)
        raise ArgumentError, 'tag is not set.' unless tag.is_a?(String)

        @fiber = Fiber.new do
            Nokogiri::XML::SAX::Parser.new(SAXDoc.new(tag)).parse(File.open(file_path)) {|ctx| ctx.recovery = true}
            Fiber.yield(nil)
        end
    end

    #
    # 指定された tag の XMLエレメントを順次処理する Enumerator オブジェクトを返します
    #
    # @return [Enumerator] XMLエレメントを順次処理する Enumerator オブジェクト
    #
    def enumerator
        Enumerator.new do |y|
            loop do
                res = @fiber.resume
                break unless res
                y << res
            end
        end
    end
  end

  # module Enumparse
  #   class Error < StandardError; end
  #   # Your code goes here...
  # end
end
