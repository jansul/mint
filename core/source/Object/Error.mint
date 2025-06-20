/* This module provides functions for working with `Object.Error` type. */
module Object.Error {
  /* Formats the error as string. */
  fun toString (error : Object.Error) : String {
    `#{error}.toString()`
  }

  /* Returns an `Object.Error` from a string. */
  fun fromString (error : String) : Object.Error {
    `#{error}` as Object.Error
  }
}
