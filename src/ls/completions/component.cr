module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completions(node : Ast::Component, workspace : Workspace, global : Bool = false) : Array(LSP::CompletionItem)
        name =
          node.name if global

        non_global =
          if global
            [] of LSP::CompletionItem
          else
            node.properties.map { |item| completion_item(item, workspace) } +
              node.styles.map { |item| completion_item(item, workspace) }
          end

        node.functions.map { |item| completion_item(item, workspace, name) } +
          node.constants.map { |item| completion_item(item, workspace, name) } +
          node.gets.map { |item| completion_item(item, workspace, name) } +
          non_global
      end
    end
  end
end
