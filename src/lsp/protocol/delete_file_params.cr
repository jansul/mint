module LSP
  # The parameters sent in notifications/requests for user-initiated deletes
  # of files.
  #
  # @since 3.16.0
  struct DeleteFilesParams
    include JSON::Serializable

    # Represents information on a file/folder delete.
    #
    # @since 3.16.0
    struct FileDelete
      include JSON::Serializable

      # A file:// URI for the location of the file/folder being deleted.
      property uri : String
    end

    # An array of all files/folders deleted in this operation.
    property files : Array(FileDelete)
  end
end
