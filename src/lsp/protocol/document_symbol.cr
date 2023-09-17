module LSP
  # Represents programming constructs like variables, classes, interfaces etc.
  # that appear in a document. Document symbols can be hierarchical and they
  # have two ranges: one that encloses its definition and one that points to its
  # most interesting range, e.g. the range of an identifier.
  struct DocumentSymbol
    include JSON::Serializable

    # The name of this symbol. Will be displayed in the user interface and
    # therefore must not be an empty string or a string only consisting of
    # white spaces.
    property name : String

    # More detail for this symbol, e.g the signature of a function.
    property detail : String?

    # The kind of this symbol.
    @[JSON::Field(converter: Enum::ValueConverter(LSP::SymbolKind))]
    property kind : SymbolKind

    # Tags for this document symbol.
    #
    # @since 3.16.0
    @[JSON::Field(converter: JSON::ArrayConverter(Enum::ValueConverter(LSP::SymbolTag)))]
    property tags : Array(SymbolTag)?

    # Indicates if this symbol is deprecated.
    #
    # @deprecated Use tags instead
    property deprecated : Bool?

    # The range enclosing this symbol not including leading/trailing whitespace
    # but everything else like comments. This information is typically used to
    # determine if the clients cursor is inside the symbol to reveal in the
    # symbol in the UI.
    property range : Range

    # The range that should be selected and revealed when this symbol is being
    # picked, e.g. the name of a function. Must be contained by the `range`.
    @[JSON::Field(key: "selectionRange")]
    property selection_range : Range

    # Children of this symbol, e.g. properties of a class.
    property children : Array(DocumentSymbol)?

    def initialize(
      @name,
      @detail,
      @kind,
      @range,
      @selection_range,
      @tags = nil,
      @deprecated = nil,
      @children = nil
    )
    end
  end
end
