module LSP
  struct FileOperationsServerCapabilities
    include JSON::Serializable

    # The server is interested in receiving didCreateFiles notifications.
    @[JSON::Field(key: "didCreate")]
    property did_create : FileOperationRegistrationOptions?

    # The server is interested in receiving willCreateFiles requests.
    @[JSON::Field(key: "willCreate")]
    property will_create : FileOperationRegistrationOptions?

    # The server is interested in receiving didRenameFiles notifications.
    @[JSON::Field(key: "didRename")]
    property did_rename : FileOperationRegistrationOptions?

    # The server is interested in receiving willRenameFiles requests.
    @[JSON::Field(key: "willRename")]
    property will_rename : FileOperationRegistrationOptions?

    # The server is interested in receiving didDeleteFiles file notifications.
    @[JSON::Field(key: "didDelete")]
    property did_delete : FileOperationRegistrationOptions?

    # The server is interested in receiving willDeleteFiles file notifications.
    @[JSON::Field(key: "willDelete")]
    property will_delete : FileOperationRegistrationOptions?

    def initialize(
      @did_create = nil,
      @will_create = nil,
      @did_rename = nil,
      @will_rename = nil,
      @did_delete = nil,
      @will_delete = nil
    )
    end
  end
end
