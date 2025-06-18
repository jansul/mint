module Mint
  module LS
    class Completion
      KEYWORD_COMPLETIONS =
        %w(
          component module provider store state property connect exposing
          style or return let if else async get fun dbg encode decode case
          as use next of when global type @asset @svg @format @inline
          @highlight @highlight-file
        ).map do |keyword|
          LSP::CompletionItem.new(
            kind: LSP::CompletionItemKind::Keyword,
            insert_text: keyword,
            filter_text: keyword,
            sort_text: keyword,
            detail: "Keyword",
            label: keyword)
        end

      HTML_TAG_COMPLETIONS =
        {{ read_file("#{__DIR__}/../assets/html_tags").strip }}
          .lines
          .map do |name|
            LSP::CompletionItem.new(
              kind: LSP::CompletionItemKind::Snippet,
              insert_text: "<#{name}>${0}</#{name}>",
              detail: "HTML Tag",
              filter_text: name,
              sort_text: name,
              label: name)
          end

      def initialize(
        *,
        @type_checker : TypeChecker | Nil,
        @snippet_support : Bool,
        @workspace : Workspace,
      )
      end

      def process(params : LSP::CompletionParams)
        ast =
          @workspace.unchecked_ast

        global_completions =
          (
            ast.stores +
              ast.unified_modules +
              ast.components.select(&.global?)
          ).flat_map { |node| completions(node, global: true) }

        scope_completions =
          ast.nodes_at_cursor(
            column: params.position.character,
            path: params.text_document.path,
            line: params.position.line + 1
          ).flat_map { |node| completions(node) }

        component_completions =
          ast.components.map { |node| completion_item(node) }

        type_completions =
          ast.type_definitions.flat_map { |node| completions(node) }

        (global_completions +
          component_completions +
          scope_completions +
          type_completions +
          HTML_TAG_COMPLETIONS +
          KEYWORD_COMPLETIONS)
          .compact
          .sort_by!(&.label)
          .map! do |item|
            item.insert_text =
              item.insert_text
                .gsub(/\$\d/, "")
                .gsub(/\$\{.*\}/, "") unless @snippet_support
            item
          end
      end

      def completions(node : Ast::Node, global : Bool = false)
        [] of LSP::CompletionItem
      end
    end
  end
end
