module Mint
  class Ast
    class Provider < Node
      getter subscription, functions, name, comment, comments
      getter gets, states, constants

      def initialize(@functions : Array(Function),
                     @constants : Array(Constant),
                     @comments : Array(Comment),
                     @states : Array(State),
                     @subscription : TypeId,
                     @comment : Comment?,
                     @gets : Array(Get),
                     @name : TypeId,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
