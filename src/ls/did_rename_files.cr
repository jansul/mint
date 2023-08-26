module Mint
  module LS
    class DidRenameFiles < LSP::NotificationMessage
      property params : LSP::RenameFilesParams

      def execute(server)
        workspace =
          server.workspace!

        params.files.each do |file|
          old_uri =
            URI.parse(file.old_uri)

          new_uri =
            URI.parse(file.new_uri)

          workspace.rename_file(old_uri.path, new_uri.path)

          server.log("Renamed #{old_uri.path} to #{new_uri.path}")
        end
      end
    end
  end
end
