module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::HtmlElement, server : Server, workspace : Workspace, stack : Array(Ast::Node))
        node.styles.each do |style|
          next unless cursor_intersects?(style)

          return definition(style, server, workspace, stack)
        end

        node.attributes.each do |attribute|
          next unless cursor_intersects?(attribute)

          return definition(attribute, server, workspace, stack)
        end
      end
    end
  end
end