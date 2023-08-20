module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completions(node : Ast::Module, workspace : Workspace, global : Bool = false) : Array(LSP::CompletionItem)
        name =
          node.name if global

        node.functions.map { |item| completion_item(item, workspace, name) } +
          node.constants.map { |item| completion_item(item, workspace, name) }
      end
    end
  end
end
