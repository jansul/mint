module LSP
  struct Workspace
    include JSON::Serializable

    # The server supports workspace folder.
    @[JSON::Field(key: "workspaceFolders")]
    property workspace_folders : WorkspaceFolders

    # The server is interested in file notifications/requests.
    #
    # @since 3.16.0
    @[JSON::Field(key: "fileOperations")]
    property file_operations : FileOperationsServerCapabilities?

    def initialize(@workspace_folders, @file_operations = nil)
    end
  end
end
