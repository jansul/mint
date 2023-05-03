module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::EnumId, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        if name = node.name
          enum_node =
            workspace.ast.enums.find(&.name.value.==(name.value))

          if enum_node
            if cursor_intersects?(name)
              location_link server, name, enum_node.name, enum_node
            else
              if cursor_intersects?(node.option)
                option =
                  enum_node.options.find(&.value.value.==(node.option.value))

                if option
                  location_link server, node.option, option.value, option
                end
              end
            end
          end
        end
      end
    end
  end
end
