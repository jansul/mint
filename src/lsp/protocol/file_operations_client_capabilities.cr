module LSP
  struct FileOperationsClientCapabilities
    include JSON::Serializable

    # Whether the client supports dynamic registration for file
    # requests/notifications.
    @[JSON::Field(key: "dynamicRegistration")]
    property dynamic_registration : Bool?

    # The client has support for sending didCreateFiles notifications.
    @[JSON::Field(key: "didCreate")]
    property did_create : Bool?

    # The client has support for sending willCreateFiles requests.
    @[JSON::Field(key: "willCreate")]
    property will_create : Bool?

    # The client has support for sending didRenameFiles notifications.
    @[JSON::Field(key: "didRename")]
    property did_rename : Bool?

    # The client has support for sending willRenameFiles requests.
    @[JSON::Field(key: "willRename")]
    property will_rename : Bool?

    # The client has support for sending didDeleteFiles notifications.
    @[JSON::Field(key: "didDelete")]
    property did_delete : Bool?

    # The client has support for sending willDeleteFiles requests.
    @[JSON::Field(key: "willDelete")]
    property will_delete : Bool?

    def initialize(
      @dynamic_registration = nil,
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
