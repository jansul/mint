module Mint
  module LS
    class Server < LSP::Server
      # Lifecycle methods
      method "initialize", Initialize
      method "shutdown", Shutdown
      method "exit", Exit

      # Text document related methods
      method "textDocument/willSaveWaitUntil", WillSaveWaitUntil
      method "textDocument/semanticTokens/full", SemanticTokens
      method "textDocument/foldingRange", FoldingRange
      method "textDocument/formatting", Formatting
      method "textDocument/completion", Completion
      method "textDocument/codeAction", CodeAction
      method "textDocument/definition", Definition
      method "textDocument/didChange", DidChange
      method "textDocument/hover", Hover

      method "workspace/didDeleteFiles", DidDeleteFiles
      method "workspace/didRenameFiles", DidRenameFiles

      property params : LSP::InitializeParams(InitializationOptions)? = nil

      property errors = {} of String => Error

      @workspace : Workspace? = nil

      def workspace! : Workspace
        @workspace || raise "Language server has not initialized workspace"
      end

      def workspace=(@workspace)
        log("Workspace has been set")

        workspace!.on "change" do |path, result|
          case result
          when Ast
            log("Something has changed!  #{result}")

            publish_diagnostics_params = LSP::PublishDiagnosticsParams.new(
              uri: "file://#{path}",
              diagnostics: [] of LSP::Diagnostic
            )

            send_notification(
              method: "textDocument/publishDiagnostics",
              params: publish_diagnostics_params)
          when Error
            log("There has been an error #{path} #{result}")

            result.locals.each do |key, value|
              case value
              when String
                log("#{key}: Type is String ")
              when Ast::Node
                log("#{key}: Type is Ast::Node ")

                range = LSP::Range.new(
                  start: LSP::Position.new(
                    line: value.location.start[0] - 1,
                    character: value.location.start[1]
                  ),
                  end: LSP::Position.new(
                    line: value.location.end[0] - 1,
                    character: value.location.end[1]
                  )
                )

                diagnostics = [] of LSP::Diagnostic
                diagnostics << LSP::Diagnostic.new(
                  range: range,
                  severity: LSP::DiagnosticSeverity::Error,
                  code: 1234,
                  source: "mint",
                  message: "Expected closing parentheses"
                )

                publish_diagnostics_params = LSP::PublishDiagnosticsParams.new(
                  uri: "file://#{path}",
                  diagnostics: diagnostics
                )

                send_notification(
                  method: "textDocument/publishDiagnostics",
                  params: publish_diagnostics_params)
              when TypeChecker::Checkable
                log("#{key}: Type is TypeChecker::Checkable ")
              when Array(TypeChecker::Checkable)
                log("#{key}: Type is Array(TypeChecker::Checkable) ")
              when Tuple(Ast::Node, Int32 | Array(Int32))
                log("#{key}: Type is Tuple(Ast::Node, Int32 | Array(Int32))")
              when Array(String)
                log("#{key}: Type is Array(String)")
              end
            end
          end
        end
      end

      # Logs the given stack.
      def debug_stack(stack : Array(Ast::Node))
        stack.each_with_index do |item, index|
          class_name = item.class

          if index.zero?
            log(class_name.to_s)
          else
            log("#{" " * (index - 1)} ↳ #{class_name}")
          end
        end
      end

      # Returns the nodes at the given cursor (position)
      def nodes_at_cursor(path : String, position : LSP::Position) : Array(Ast::Node)
        nodes_at_path(path)
          .select!(&.location.contains?(position.line + 1, position.character))
      end

      def nodes_at_cursor(params : LSP::TextDocumentPositionParams) : Array(Ast::Node)
        nodes_at_cursor(params.path, params.position)
      end

      def nodes_at_cursor(params : LSP::CodeActionParams) : Array(Ast::Node)
        nodes_at_cursor(params.text_document.path, params.range.start)
      end

      def nodes_at_path(path : String)
        workspace!
          .ast
          .nodes
          .select(&.input.file.==(path))
      end
    end
  end
end
