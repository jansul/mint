module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::EnumDestructuring, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        name = node.name
        option = node.option

        found_enum =
          workspace.ast.enums.find(&.name.value.==(name.try(&.value)))

        found_option =
          found_enum.try &.options.find(&.value.value.==(option.value))

        case
        when found_enum && name && cursor_intersects?(name)
          location_link server, name, found_enum.name, found_enum
        when found_option && cursor_intersects?(option)
          location_link server, option, found_option.value, found_option
        end
      end
    end
  end
end
