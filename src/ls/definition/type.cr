module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Type, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        return unless cursor_intersects?(node.name)

        enum_node =
          workspace.ast.enums.find(&.name.value.==(node.name.value))

        if enum_node
          location_link server, node.name, enum_node.name, enum_node
        else
          record =
            workspace.ast.records.find(&.name.value.==(node.name.value))

          if record
            location_link server, node.name, record.name, record
          end
        end
      end
    end
  end
end
