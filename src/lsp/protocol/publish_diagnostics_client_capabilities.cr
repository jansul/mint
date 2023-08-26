module LSP
  struct PublishDiagnosticsClientCapabilities
    include JSON::Serializable

    struct TagSupport
      include JSON::Serializable

      # The tags supported by the client.
      @[JSON::Field(key: "valueSet")]
      property value_set : Array(DiagnosticTag)
    end

    # Whether the clients accepts diagnostics with related information.
    @[JSON::Field(key: "relatedInformation")]
    property related_information : Bool?

    # Client supports the tag property to provide meta data about a diagnostic.
    # Clients supporting tags have to handle unknown tags gracefully.
    #
    # @since 3.15.0
    @[JSON::Field(key: "tagSupport")]
    property tag_support : TagSupport?

    # Whether the client interprets the version property of the
    # `textDocument/publishDiagnostics` notification's parameter.
    #
    # @since 3.15.0
    @[JSON::Field(key: "versionSupport")]
    property version_support : Bool?

    # Client supports a codeDescription property
    #
    # @since 3.16.0
    @[JSON::Field(key: "codeDescriptionSupport")]
    property code_description_support : Bool?

    # Whether code action supports the `data` property which is
    # preserved between a `textDocument/publishDiagnostics` and
    # `textDocument/codeAction` request.
    #
    # @since 3.16.0
    @[JSON::Field(key: "dataSupport")]
    property data_support : Bool?
  end
end
