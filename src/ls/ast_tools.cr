module Mint
  class AstTools
    class AstIncludes
      def includes?(ast : Ast, node : Ast::Node)
        includes = ->(x : Ast::Node) { includes?(x, node) }

        # ast.operators.any?(includes) ||
        #   ast.keywords.any?(includes) ||
        ast.records.any?(includes) ||
          ast.unified_modules.any?(includes) ||
          ast.components.any?(includes) ||
          ast.providers.any?(includes) ||
          ast.comments.any?(includes) ||
          ast.modules.any?(includes) ||
          ast.routes.any?(includes) ||
          ast.suites.any?(includes) ||
          ast.stores.any?(includes) ||
          ast.enums.any?(includes) ||
          ast.nodes.any?(includes)
      end

      def includes?(haystack : Nil, needle : Ast::Node)
        false
      end

      def includes?(haystack : Int64, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Node, needle : Ast::Node)
        haystack == needle
      end

      def includes?(haystack : Tuple(Ast::Variable, Ast::Node), needle : Ast::Node)
      end

      def includes?(haystack : Array(Tuple(Ast::Variable, Ast::Node)), needle : Ast::Node)
        haystack.any? { |tuple|
          includes?(tuple[0], needle) ||
            includes?(tuple[0], needle)
        }
      end

      def includes?(haystack : Array(Ast::Node), needle : Ast::Node)
        haystack.any? { |node| includes?(node, needle) }
      end

      def includes?(haystack : Ast::Access, needle : Ast::Node)
        includes?(haystack.field, needle) ||
          includes?(haystack.lhs, needle)
      end

      def includes?(haystack : Ast::Argument, needle : Ast::Node)
        includes?(haystack.type, needle) ||
          includes?(haystack.name, needle) ||
          includes?(haystack.default, needle)
      end

      def includes?(haystack : Ast::ArrayAccess, needle : Ast::Node)
        includes?(haystack.lhs, needle) ||
          includes?(haystack.index, needle)
      end

      def includes?(haystack : Ast::ArrayDestructuring, needle : Ast::Node)
        includes?(haystack.items, needle)
      end

      def includes?(haystack : Ast::ArrayLiteral, needle : Ast::Node)
        includes?(haystack.items, needle) ||
          includes?(haystack.type, needle)
      end

      def includes?(haystack : Ast::Block, needle : Ast::Node)
        includes?(haystack.statements, needle)
      end

      def includes?(haystack : Ast::Call, needle : Ast::Node)
        includes?(haystack.arguments, needle) ||
          includes?(haystack.expression, needle)
      end

      def includes?(haystack : Ast::CaseBranch, needle : Ast::Node)
        includes?(haystack.expression, needle) ||
          includes?(haystack.match, needle)
      end

      def includes?(haystack : Ast::Case, needle : Ast::Node)
        includes?(haystack.branches, needle) ||
          includes?(haystack.comments, needle) ||
          includes?(haystack.condition, needle)
      end

      def includes?(haystack : Ast::Component, needle : Ast::Node)
        includes?(haystack.refs, needle) ||         #  : Array(Tuple(Variable, Node)),
          includes?(haystack.properties, needle) || #  : Array(Property),
          includes?(haystack.constants, needle) ||  #  : Array(Constant),
          includes?(haystack.functions, needle) ||  #  : Array(Function),
          includes?(haystack.comments, needle) ||   #  : Array(Comment),
          includes?(haystack.connects, needle) ||   #  : Array(Connect),
          includes?(haystack.states, needle) ||     #  : Array(State),
          includes?(haystack.styles, needle) ||     #  : Array(Style),
          includes?(haystack.comment, needle) ||    #  : Comment?,
          includes?(haystack.gets, needle) ||       #  : Array(Get),
          includes?(haystack.uses, needle) ||       #  : Array(Use),
          includes?(haystack.name, needle)          #  : TypeId,
      end

      def includes?(haystack : Ast::Connect, needle : Ast::Node)
        includes?(haystack.keys, needle) ||
          includes?(haystack.store, needle)
      end

      def includes?(haystack : Ast::ConnectVariable, needle : Ast::Node)
        includes?(haystack.variable, needle) ||
          includes?(haystack.name, needle)
      end

      def includes?(haystack : Ast::Constant, needle : Ast::Node)
        includes?(haystack.value, needle) ||
          includes?(haystack.comment, needle) ||
          includes?(haystack.name, needle)
      end

      def includes?(haystack : Ast::CssDefinition, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::CssFontFace, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::CssKeyframes, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::CssNestedAt, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::CssSelector, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Data, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Decode, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Encode, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Enum, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::EnumDestructuring, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::EnumId, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::EnumOption, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::EnumRecord, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::EnumRecordDefinition, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Env, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::ForCondition, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::For, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Function, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Get, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::HereDoc, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::HtmlAttribute, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::HtmlComponent, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::HtmlElement, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::HtmlExpression, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::HtmlFragment, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::HtmlStyle, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::If, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::InlineFunction, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Interpolation, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Js, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::MemberAccess, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::ModuleAccess, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Module, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::NegatedExpression, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::NextCall, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::NumberLiteral, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Operation, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Option, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::ParenthesizedExpression, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Pipe, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Property, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Provider, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Record, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::RecordDefinition, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::RecordDefinitionField, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::RecordField, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::RecordUpdate, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::RegexpLiteral, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::ReturnCall, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Route, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Routes, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Spread, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::State, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Statement, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Store, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::StringLiteral, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Style, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Suite, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Test, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::TupleDestructuring, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::TupleLiteral, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Type, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::TypeId, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::TypeVariable, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::UnaryMinus, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Use, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Variable, needle : Ast::Node)
        false
      end

      def includes?(haystack : Ast::Void, needle : Ast::Node)
        false
      end
    end
  end
end
