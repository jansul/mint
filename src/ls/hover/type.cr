module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::Type, workspace) : Array(String)
        enum_node =
          workspace
            .ast
            .enums
            .find(&.name.value.==(node.name.value))

        if enum_node
          hover(enum_node, workspace)
        else
          record =
            workspace
              .type_checker
              .records
              .find(&.name.==(node.name.value))
              .try(&.to_pretty)

          type =
            workspace.formatter.format(node)

          ["```\n#{record || type}\n```"]
        end
      end
    end
  end
end
