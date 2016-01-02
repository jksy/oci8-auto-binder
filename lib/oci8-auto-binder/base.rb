require 'oci8'
require 'oracle-sql-parser'

module OCI8AutoBinder
  ORIGINAL_OCI8 = ::OCI8
  @replace = false
  @logger = nil

  # OCI8をOCI8AutoBinder::OCI8に置き換えます
  # replace to OCI8AutoBinder::OCI8 from OCI8
  def self.replace_original_class!
    unless @replaced
      Object.const_set(:OCI8, ::OCI8AutoBinder::OCI8)
      @replaced = true
    end
  end

  # パースした結果を保存するログファイルを渡します
  # set Logger for the purpose of logging
  def self.logger=(logger)
    @logger = logger
  end

  # get logger
  def self.logger
    @logger
  end

end

# OCI8#execを上書きし、OracleSqlParser::Grammar::GrammarParserで構文解析した結果をOCI8#execに渡します。
# Pass the result that was parsed by OracleSqlParser::Grammar::GrammarParser to OCI8#exec
class OCI8AutoBinder::OCI8 < ::OCI8

  # OracleSqlParser::Grammar::GrammarParserで構文解析し、NumberLiteralとTextLiteralをbinding変数としてOCI8#execに渡す
  def exec_with_auto_binder(sql, *bindvars, &block)
    if bindvars.length != 0
      logger.info {"FOUND_BINDVARS:#{sql}, #{bindvars.inspect}"} if logger
      return exec_without_auto_binder(sql, *bindvars, &block)
    end
    syntax_tree = parser.parse(sql)
    unless syntax_tree
      logger.error {"PARSE_ERROR:#{sql}, #{bindvars.inspect}"} if logger
      return exec_without_auto_binder(sql, *bindvars, &block)
    end
    p = syntax_tree.ast.to_parameterized
    if p.params.size == 0
      logger.info {"NO_PARAMS:#{sql}, #{bindvars.inspect}"} if logger
      return exec_without_auto_binder(sql, *bindvars, &block)
    end

    values = p.params.values.map do |v|
      case v
      when OracleSqlParser::Ast::NumberLiteral
        v.to_decimal
      when OracleSqlParser::Ast::TextLiteral
        v.to_s
      else
        raise 'unsupported type'
      end
    end

    logger.info {"PARSE_SUCCESS:#{sql}, #{p.to_sql}, #{values.inspect}"} if logger
    return exec_without_auto_binder(p.to_sql, *values, &block)
  end

  alias :exec_without_auto_binder :exec
  alias :exec :exec_with_auto_binder

  def logger
    OCI8AutoBinder.logger
  end

  private
  # GrammerParserを取得する
  # get GrammerParser
  def parser
    @parser ||= OracleSqlParser::Grammar::GrammarParser.new
  end
end
