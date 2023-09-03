module Mint
  module LS
    # This is the class that handles the "textDocument/definition" request.
    class Definition < LSP::RequestMessage
      property params : LSP::TextDocumentPositionParams

      struct DefinitionLink
        property source : Ast::Node
        property target : Ast::Node
        property parent : Ast::Node

        def initialize(@source, @target, @parent)
        end
      end

      def execute(server) : Array(LSP::LocationLink | LSP::Location) | LSP::Location | Nil
        workspace = server.workspace!

        unless workspace.error
          stack =
            server.nodes_at_cursor(params)

          return unless node = stack[0]?

          has_link_support =
            server
              .params
              .try(&.capabilities.text_document)
              .try(&.definition)
              .try(&.link_support) || false

          storage_path =
            server
              .params
              .try(&.initialization_options)
              .try(&.storage_path)

          link = definition(node, workspace, stack)

          return if link.nil?

          links = link.is_a?(Array) ? link : [link]

          combined = links.map do |link|
            target_is_core =
              Core.ast.nodes.includes?(link.target) ||
                Core.ast.nodes.includes?(link.parent)

            target_uri = if target_is_core
                           # Do not link to core files unless they are stored on disk
                           next unless storage_path

                           core_path = Path[storage_path, VERSION, "core"]

                           server.log(link.target.location.filename, 4)

                           path = Path[core_path, link.target.location.filename]
                           path.to_uri.to_s
                         else
                           "file://#{link.target.location.filename}"
                         end

            if has_link_support
              LSP::LocationLink.new(
                origin_selection_range: to_lsp_range(link.source.location),
                target_uri: target_uri,
                target_range: to_lsp_range(link.parent.location),
                target_selection_range: to_lsp_range(link.target.location)
              )
            else
              LSP::Location.new(
                range: to_lsp_range(link.target.location),
                uri: target_uri,
              )
            end
          end

          compacted = combined.compact

          # Prefer nil rather than an empty array
          return nil if compacted.empty?

          compacted

          # Return a singular `LSP::Location` if possible
          # return compacted.first if compacted.size == 1

          # case links
          # when Array(DefinitionLink)
          #   # Prefer nil rather than an empty array
          #   return nil if links.empty?

          #   unless has_link_support
          #     # Return a singular `LSP::Location` if possible
          #     return links.first.to_lsp_location(server) if links.size == 1

          #     # Otherwise return an array
          #     return links.map(&.to_lsp_location(server))
          #   end

          #   return links.map(&.to_lsp_location_link(server))
          # when DefinitionLink
          #   return links.to_lsp_location(server) if !has_link_support

          #   [links.to_lsp_location_link(server)]
          # end
        end
      end

      def definition(node : Ast::Node, workspace : Workspace, stack : Array(Ast::Node))
        nil
      end

      def cursor_intersects?(node : Ast::Node, position : LSP::Position) : Bool
        node.location.contains?(position.line + 1, position.character)
      end

      def cursor_intersects?(node : Ast::Node, params : LSP::TextDocumentPositionParams) : Bool
        cursor_intersects?(node, params.position)
      end

      def cursor_intersects?(node : Ast::Node) : Bool
        cursor_intersects?(node, params)
      end

      def find_component(workspace : Workspace, name : String) : Ast::Component?
        # Do not include any core component
        return if Core.ast.components.any?(&.name.value.== name)

        workspace.ast.components.find(&.name.value.== name)
      end

      def to_lsp_range(location : Ast::Node::Location) : LSP::Range
        LSP::Range.new(
          start: LSP::Position.new(
            line: location.start[0] - 1,
            character: location.start[1]
          ),
          end: LSP::Position.new(
            line: location.end[0] - 1,
            character: location.end[1]
          )
        )
      end

      # Returns a `LSP::LocationLink` that links from *source* to the *target* node
      #
      # The *parent* node is used to provide the full range for the *target* node.
      # For example, for a function, *target* would be the function name, and *parent*
      # would be the whole node, including function body and any comments
      def location_link(source : Ast::Node, target : Ast::Node, parent : Ast::Node) : DefinitionLink
        DefinitionLink.new(source, target, parent)

        # target_uri = if Core.ast.nodes.includes?(target)
        #   "file://#{target.location.filename}"
        # else
        #   "file://#{target.location.filename}"
        # end

        # target_uri =
        # .try(&.initialization_options)
        # .try(&.storage_path)
        # .try do |storage_path|
        #   FileUtils.mkdir_p storage_path

        #   Dir.cd(storage_path) do
        #     Core.files.each do |file|
        #       dest_path =
        #         Path[storage_path, "core", VERSION, file.path]

        # LSP::LocationLink.new(
        #   origin_selection_range: to_lsp_range(source.location),
        #   target_uri: "file://#{target.location.filename}",
        #   target_range: to_lsp_range(parent.location),
        #   target_selection_range: to_lsp_range(target.location)
        # )
      end
    end
  end
end
