module LSP
  # A pattern kind describing if a glob pattern matches a file a folder or
  # both.
  #
  # @since 3.16.0
  enum FileOperationPatternKind
    # The pattern matches a file only.
    File

    #  The pattern matches a folder only.
    Folder
  end

  # Matching options for the file operation pattern.
  #
  # @since 3.16.0
  struct FileOperationPatternOptions
    include JSON::Serializable

    # The pattern should be matched ignoring casing.
    @[JSON::Field(key: "ignoreCase")]
    property ignore_case : Bool?

    def initialize(@ignore_case = nil)
    end
  end

  # A pattern to describe in which file operation requests or notifications
  # the server is interested in.
  #
  # @since 3.16.0
  struct FileOperationPattern
    include JSON::Serializable

    # The glob pattern to match. Glob patterns can have the following syntax:
    # - `*` to match one or more characters in a path segment
    # - `?` to match on one character in a path segment
    # - `**` to match any number of path segments, including none
    # - `{}` to group sub patterns into an OR expression. (e.g. `**​/*.{ts,js}`
    #   matches all TypeScript and JavaScript files)
    # - `[]` to declare a range of characters to match in a path segment
    #   (e.g., `example.[0-9]` to match on `example.0`, `example.1`, …)
    # - `[!...]` to negate a range of characters to match in a path segment
    #   (e.g., `example.[!0-9]` to match on `example.a`, `example.b`, but
    #   not `example.0`)
    property glob : String

    # Whether to match files or folders with this pattern.
    #
    # Matches both if undefined.
    property matches : FileOperationPatternKind?

    # Additional options used during matching.
    property options : FileOperationPatternOptions?

    def initialize(@glob, @matches = nil, @options = nil)
    end
  end

  # A filter to describe in which file operation requests or notifications
  # the server is interested in.
  #
  # @since 3.16.0
  struct FileOperationFilter
    include JSON::Serializable

    # A Uri like `file` or `untitled`.
    property scheme : String?

    # The actual file operation pattern.
    property pattern : FileOperationPattern

    def initialize(@pattern, @scheme = nil)
    end
  end

  # The options to register for file operations.
  #
  # @since 3.16.0
  struct FileOperationRegistrationOptions
    include JSON::Serializable

    # The actual filters.
    property filters : Array(FileOperationFilter)

    def initialize(@filters)
    end
  end
end
