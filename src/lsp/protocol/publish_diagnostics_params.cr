module LSP
  struct PublishDiagnosticsParams
    include JSON::Serializable

    # The URI for which diagnostic information is reported.
    property uri : String

    # Optional the version number of the document the diagnostics are published
    # for.
    #
    # @since 3.15.0
    property version : Int32?

    # An array of diagnostic information items.
    property diagnostics : Array(Diagnostic)

    def initialize(@uri, @diagnostics, @version = nil)
    end
  end
end
