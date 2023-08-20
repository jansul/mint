module Mint
  module LS
    class CodeAction < LSP::RequestMessage
      property params : LSP::CodeActionParams

      def actions(node : Ast::Module, workspace : Workspace)
        [
          ModuleActions.order_entities(node, workspace, params.text_document.uri),
        ]
      end

      def actions(node : Ast::Provider, workspace : Workspace)
        [
          ProviderActions.order_entities(node, workspace, params.text_document.uri),
        ]
      end

      def actions(node : Ast::Node, workspace : Workspace)
        [] of LSP::CodeAction
      end

      def execute(server)
        workspace = server.workspace!

        return [] of LSP::CodeAction if workspace.error

        server
          .nodes_at_cursor(params)
          .reduce([] of LSP::CodeAction) do |memo, node|
            memo + actions(node, workspace)
          end
      end
    end
  end
end
