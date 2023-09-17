module LSP
  enum SymbolKind
    File          =  1
    Module        =  2
    Namespace     =  3
    Package       =  4
    Class         =  5
    Method        =  6
    Property      =  7
    Field         =  8
    Constructor   =  9
    Enum          = 10
    Interface     = 11
    Function      = 12
    Variable      = 13
    Constant      = 14
    String        = 15
    Number        = 16
    Boolean       = 17
    Array         = 18
    Object        = 19
    Key           = 20
    Null          = 21
    EnumMember    = 22
    Struct        = 23
    Event         = 24
    Operator      = 25
    TypeParameter = 26
  end

  enum SymbolTag
    # Render a symbol as obsolete, usually using a strike-out.
    Deprecated = 1
  end

  struct SymbolKindClientCapabilities
    include JSON::Serializable

    # The symbol kind values the client supports. When this
    # property exists the client also guarantees that it will
    # handle values outside its set gracefully and falls back
    # to a default value when unknown.
    #
    # If this property is not present the client only supports
    # the symbol kinds from `File` to `Array` as defined in
    # the initial version of the protocol.
    @[JSON::Field(key: "valueSet", converter: JSON::ArrayConverter(Enum::ValueConverter(LSP::SymbolKind)))]
    property value_set : Array(SymbolKind)?
  end

  struct TagSupportClientCapabilities
    include JSON::Serializable

    # The tags supported by the client.
    @[JSON::Field(key: "valueSet", converter: JSON::ArrayConverter(Enum::ValueConverter(LSP::SymbolTag)))]
    property value_set : Array(SymbolTag)
  end

  struct DocumentSymbolClientCapabilities
    include JSON::Serializable

    # Whether definition supports dynamic registration.
    @[JSON::Field(key: "dynamicRegistration")]
    property dynamic_registration : Bool?

    # Specific capabilities for the `SymbolKind` in the
    # `textDocument/documentSymbol` request.
    @[JSON::Field(key: "symbolKind")]
    property symbol_kind : SymbolKindClientCapabilities?

    # The client supports hierarchical document symbols.
    @[JSON::Field(key: "hierarchicalDocumentSymbolSupport")]
    property hierarchical_document_symbol_support : Bool?

    #  The client supports tags on `SymbolInformation`. Tags are supported on
    # `DocumentSymbol` if `hierarchicalDocumentSymbolSupport` is set to true.
    #  Clients supporting tags have to handle unknown tags gracefully.
    #
    #  @since 3.16.0
    @[JSON::Field(key: "tagSupport")]
    property tag_support : TagSupportClientCapabilities?

    # The client supports an additional label presented in the UI when
    # registering a document symbol provider.
    #
    # @since 3.16.0
    @[JSON::Field(key: "labelSupport")]
    property labelSupport : Bool?
  end
end
