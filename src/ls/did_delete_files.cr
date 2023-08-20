module Mint
    module LS
      class DidDeleteFiles < LSP::NotificationMessage
        property params : LSP::DidChangeTextDocumentParams
  
        def execute(server)
          uri =
            URI.parse(params.text_document.uri)
  
          workspace =
            server.workspace!
  
          workspace.update(params.content_changes.first.text, uri.path)
        end
      end
    end
  end
  