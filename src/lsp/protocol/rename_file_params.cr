module LSP
  # The parameters sent in notifications/requests for user-initiated renames
  # of files.
  #
  # @since 3.16.0
  struct RenameFilesParams
    include JSON::Serializable

    # Represents information on a file/folder rename.
    #
    # @since 3.16.0
    struct FileRename
      include JSON::Serializable

      # A file:// URI for the original location of the file/folder being renamed.
      @[JSON::Field(key: "oldUri")]
      property old_uri : String

      # A file:// URI for the new location of the file/folder being renamed.
      @[JSON::Field(key: "newUri")]
      property new_uri : String
    end

    # An array of all files/folders renamed in this operation. When a folder
    # is renamed, only the folder will be included, and not its children.
    property files : Array(FileRename)
  end
end
