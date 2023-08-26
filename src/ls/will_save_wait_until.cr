module Mint
  module LS
    class WillSaveWaitUntil < LSP::RequestMessage
      property params : LSP::WillSaveTextDocumentParams

      def execute(server)
        uri =
          URI.parse(params.text_document.uri)

        workspace =
          server.workspace!

        formatted =
          workspace.format(uri.path.to_s)

        # If there is an error show that
        if workspace.error
          server.show_message_request("Could not format the file because it contains errors!", 1)
        end

        # Respond with the formatted document or an empty response message
        # because SublimeText LSP client freezes if an error response is
        # returns for this
        if !workspace.error && formatted
          [
            LSP::TextEdit.new(new_text: formatted, range: LSP::Range.new(
              start: LSP::Position.new(line: 0, character: 0),
              end: LSP::Position.new(line: 9999, character: 999)
            )),
          ]
        else
          %w[]
        end
      end
    end
  end
end
