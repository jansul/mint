module Mint
  module LS
    class Completion < LSP::RequestMessage
      def completions(node : Ast::Function, workspace : Workspace) : Array(LSP::CompletionItem)
        node.arguments.map { |item| completion_item(item, workspace) }
      end
    end
  end
end
