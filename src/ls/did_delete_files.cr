module Mint
  module LS
    class DidDeleteFiles < LSP::NotificationMessage
      property params : LSP::DeleteFilesParams

      def execute(server)
        workspace =
          server.workspace!

        params.files.each do |file|
          uri =
            URI.parse(file.uri)

          workspace.delete_file(uri.path)

          server.log("Deleted #{uri.path}")
        end
      end
    end
  end
end
