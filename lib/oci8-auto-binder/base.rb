require 'oci8'
require 'oracle-sql-parser'

module OCI8AutoBinder
  ORIGINAL_OCI8 = ::OCI8
  @replace = false
  def self.replace_original_class!
    unless @replaced
      Object.const_set(:OCI8, ::OCI8AutoBinder::OCI8)
      @replaced = true
    end
  end
end

class OCI8AutoBinder::OCI8 < ::OCI8
  def parser
    @parser ||= OracleSqlParser::Grammar::GrammarParser.new
  end

  def exec_with_auto_binder(sql, *bindvars, &block)
    if bindvars.length != 0
      return exec_without_auto_binder(sql, *bindvars, &block)
    end
    syntax_tree = parser.parse(sql)
    unless syntax_tree
      return exec_without_auto_binder(sql, *bindvars, &block)
    end
    p = syntax_tree.ast.to_parameternized
    if p.params.size == 0
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

    return exec_without_auto_binder(p.to_sql, *values, &block)
  end

  alias :exec_without_auto_binder :exec
  alias :exec :exec_with_auto_binder
end
