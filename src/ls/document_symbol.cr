module Mint
  module LS
    # This is the class that handles the "textDocument/documentSymbol" request.
    class DocumentSymbol < LSP::RequestMessage
      property params : LSP::DocumentSymbolParams

      def execute(server) : Array(LSP::DocumentSymbol) | Nil
        # Only support `DocumentSymbol` type responses
        return unless server
                        .params
                        .try(&.capabilities.text_document)
                        .try(&.document_symbol)
                        .try(&.hierarchical_document_symbol_support)

        uri =
          URI.parse(params.text_document.uri)

        workspace =
          Workspace[uri.path.to_s]

        # unless workspace.error
          ast =
            workspace[uri.path.to_s]

          symbols?(workspace, ast, nil)
        # end
      end

      def symbols?(workspace, ast : Ast, context : Ast::Node? = nil) : Array(LSP::DocumentSymbol)
        nodes = (
          ast.records +
          ast.providers +
          ast.components +
          ast.modules +
          ast.routes +
          ast.stores +
          ast.suites +
          ast.enums
        )

        symbols?(workspace, nodes, context)
      end

      def symbols?(workspace, node : Ast::Node, context : Ast::Node? = nil) : Array(LSP::DocumentSymbol)
        symbols = [] of LSP::DocumentSymbol

        case node
        in Ast::Access
        in Ast::Argument
          return symbols?(workspace, node.name, node)
        in Ast::ArrayAccess
        in Ast::ArrayDestructuring
          return symbols?(workspace, node.items, context)
        in Ast::ArrayLiteral
        in Ast::Block
          return symbols?(workspace, node.statements, context)
        in Ast::BoolLiteral
        in Ast::Call
          return symbols?(workspace, node.arguments, context) + symbols?(workspace, node.expression, context)
        in Ast::CaseBranch
          if match = node.match
            symbols += symbols?(workspace, match, context)
          end

          case expression = node.expression
          when Ast::Node
            symbols += symbols?(workspace, expression, context)
          end
        in Ast::Case
          return symbols?(workspace, node.branches, context)
        in Ast::Comment
        in Ast::Component
          symbols << symbol?(workspace, node, context)
        in Ast::ConnectVariable
          symbols << symbol?(workspace, node, node)
        in Ast::Connect
          symbols << symbol?(workspace, node, context)
        in Ast::Constant
          symbols << symbol?(workspace, node, context)
        in Ast::CssDefinition
        in Ast::CssFontFace
        in Ast::CssKeyframes
        in Ast::CssNestedAt
        in Ast::CssSelector
        in Ast::Decode
        in Ast::Encode
        in Ast::EnumDestructuring
          return symbols?(workspace, node.parameters, context)
        in Ast::EnumId
        in Ast::EnumOption
          symbols << symbol?(workspace, node, context)
        in Ast::EnumRecordDefinition
          return symbols?(workspace, node.fields, context)
        in Ast::Enum
          symbols << symbol?(workspace, node, context)
        in Ast::Env
        in Ast::ForCondition
        in Ast::For
        in Ast::Function
          symbols << symbol?(workspace, node, context)
        in Ast::Get
          symbols << symbol?(workspace, node, context)
        in Ast::HereDoc
        in Ast::HtmlAttribute
        in Ast::HtmlComponent
        in Ast::HtmlElement
        in Ast::HtmlExpression
        in Ast::HtmlFragment
        in Ast::HtmlStyle
        in Ast::If
        in Ast::InlineFunction
          return symbols?(workspace, node.arguments, context) + symbols?(workspace, node.body, context)
        in Ast::Interpolation
        in Ast::Js
        in Ast::MemberAccess
        in Ast::ModuleAccess
        in Ast::Module
          symbols << symbol?(workspace, node, context)
        in Ast::NegatedExpression
        in Ast::NextCall
        in Ast::NumberLiteral
        in Ast::Operation
        in Ast::Option
        in Ast::ParenthesizedExpression
        in Ast::Pipe
        in Ast::Property
          symbols << symbol?(workspace, node, context)
        in Ast::Provider
        in Ast::RecordDefinitionField
          return symbols?(workspace, node.key, node)
        in Ast::RecordDefinition
          symbols << symbol?(workspace, node, context)
        in Ast::RecordField
          return symbols?(workspace, node.key, node) + symbols?(workspace, node.value, context)
        in Ast::RecordUpdate
        in Ast::Record
          return symbols?(workspace, node.fields, context)
        in Ast::RegexpLiteral
        in Ast::ReturnCall
        in Ast::Route
        in Ast::Routes
        in Ast::Spread
        in Ast::State
          symbols << symbol?(workspace, node, context)
        in Ast::Statement
          if target = node.target
            return symbols?(workspace, target, node) + symbols?(workspace, node.expression, context)
          else
            return symbols?(workspace, node.expression, context)
          end
        in Ast::Store
          symbols << symbol?(workspace, node, context)
        in Ast::StringLiteral
        in Ast::Style
          symbols << symbol?(workspace, node, context)
        in Ast::Suite
        in Ast::Test
        in Ast::TupleDestructuring
          return symbols?(workspace, node.parameters, context)
        in Ast::TupleLiteral
        in Ast::TypeId
        in Ast::TypeVariable
        in Ast::Type
        in Ast::UnaryMinus
        in Ast::Use
          symbols << symbol?(workspace, node, context)
        in Ast::Variable
          case context
          when Ast::Argument
            symbols << symbol?(workspace, node, context)
          when Ast::Statement
            symbols << symbol?(workspace, node, context)
          when Ast::RecordField
            symbols << symbol?(workspace, node, context)
          when Ast::ConnectVariable
            symbols << symbol?(workspace, node, context)
          when Ast::RecordDefinitionField
            symbols << symbol?(workspace, node, context)
          end
        in Ast::Void
        in Ast::Directives::Asset
        in Ast::Directives::Documentation
        in Ast::Directives::Format
        in Ast::Directives::Highlight
        in Ast::Directives::Inline
        in Ast::Directives::Svg
          # https://github.com/crystal-lang/crystal/issues/12796
        in Ast::Node
        end

        symbols
      end

      # Mint::Ast::Variable p
      # ↳ Mint::Ast::Argument
      # ↳ Mint::Ast::InlineFunction
      # ↳ Mint::Ast::Call

      def symbols?(workspace : Workspace, nodes : Array(Ast::Node), context : Ast::Node? = nil) : Array(LSP::DocumentSymbol)
        nodes.flat_map { |node| symbols?(workspace, node, context) }.compact
      end

      # Symbol

      def symbol?(workspace : Workspace, node : Ast::Module, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: "(module)",
          kind: LSP::SymbolKind::Class,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location),
          children: symbols?(workspace, node.functions + node.constants, context),
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Component, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: "(component)",
          kind: LSP::SymbolKind::Class,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location),
          children: symbols?(
            workspace,
            node.properties +
            node.constants +
            node.functions +
            node.connects +
            node.states +
            node.styles +
            node.gets +
            node.uses,
            context
          ),
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Store, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: "(store)",
          kind: LSP::SymbolKind::Class,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location),
          children: symbols?(
            workspace,
            node.constants +
            node.functions +
            node.states +
            node.gets,
            context
          ),
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Enum, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: "(enum)",
          kind: LSP::SymbolKind::Enum,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location),
          children: symbols?(workspace, node.options, context),
        )
      end

      def symbol?(workspace : Workspace, node : Ast::EnumOption, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.value.value,
          detail: nil,
          kind: LSP::SymbolKind::EnumMember,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.value.location),
          children: symbols?(workspace, node.parameters, context),
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Function, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: symbol_detail_text?(workspace, node),
          kind: LSP::SymbolKind::Method,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location),
          children: symbols?(workspace, node.body, context)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Property, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: symbol_detail_text?(workspace, node),
          kind: LSP::SymbolKind::Property,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Constant, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: symbol_detail_text?(workspace, node),
          kind: LSP::SymbolKind::Constant,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Connect, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.store.value,
          detail: "(connect)",
          kind: LSP::SymbolKind::Module,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.store.location),
          children: symbols?(workspace, node.keys, context)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::ConnectVariable, context : Ast::Node? = nil) : LSP::DocumentSymbol
        name = node.name || node.variable

        LSP::DocumentSymbol.new(
          name: name.value,
          detail: symbol_detail_text?(workspace, node),
          kind: LSP::SymbolKind::Property,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(name.location)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::State, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: symbol_detail_text?(workspace, node),
          kind: LSP::SymbolKind::Property,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Get, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: symbol_detail_text?(workspace, node),
          kind: LSP::SymbolKind::Method,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location),
          children: symbols?(workspace, node.body, context)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Use, context : Ast::Node? = nil) : LSP::DocumentSymbol
        # TODO: Record?
        LSP::DocumentSymbol.new(
          name: node.provider.value,
          detail: "(use)",
          kind: LSP::SymbolKind::Property,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.provider.location),
          children: symbols?(workspace, node.data, context)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Style, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: "(style)",
          kind: LSP::SymbolKind::Method,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location),
          children: symbols?(workspace, node.body, context)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::Variable, context : Ast::Node? = nil) : LSP::DocumentSymbol
        kind = case context
               when Ast::RecordField, Ast::RecordDefinitionField
                 LSP::SymbolKind::Property
               else
                 LSP::SymbolKind::Variable
               end

        LSP::DocumentSymbol.new(
          name: node.value,
          detail: symbol_detail_text?(workspace, context),
          kind: kind,
          range: to_lsp_range(context.try(&.location) || node.location),
          selection_range: to_lsp_range(node.location)
        )
      end

      def symbol?(workspace : Workspace, node : Ast::RecordDefinition, context : Ast::Node? = nil) : LSP::DocumentSymbol
        LSP::DocumentSymbol.new(
          name: node.name.value,
          detail: "(record)",
          kind: LSP::SymbolKind::Class,
          range: to_lsp_range(node.location),
          selection_range: to_lsp_range(node.name.location),
          children: symbols?(workspace, node.fields, context)
        )
      end

      def symbol_detail_text?(workspace : Workspace, node : Ast::Node?)
        case lookup = workspace.type_checker.cache[node]?
        when TypeChecker::Type
          ": #{lookup.to_pretty}"
        when TypeChecker::Record
          ": #{lookup.to_pretty}"
        when TypeChecker::Variable
          ": ?"
        else
          ": ?"
        end
      end

      def to_lsp_range(location : Ast::Node::Location) : LSP::Range
        LSP::Range.new(
          start: LSP::Position.new(
            line: location.start[0] - 1,
            character: location.start[1]
          ),
          end: LSP::Position.new(
            line: location.end[0] - 1,
            character: location.end[1]
          )
        )
      end
    end
  end
end
