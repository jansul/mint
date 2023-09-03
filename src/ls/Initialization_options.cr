module Mint
  module LS
    struct InitializationOptions
      include JSON::Serializable

      @[JSON::Field(key: "storagePath")]
      property storage_path : String?
    end
  end
end
