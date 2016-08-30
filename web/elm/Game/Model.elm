module Game.Model exposing (..)


type alias Model =
    { id : Maybe String
    , attacker : Maybe String
    , defender : Maybe String
    , turns : List Turn
    , over : Bool
    , winner : Maybe String
    }


type alias Turn =
    { player_id : String
    , x : Int
    , y : Int
    , result : String
    }


initialModel : Model
initialModel =
    { id = Nothing
    , attacker = Nothing
    , defender = Nothing
    , turns = []
    , over = False
    , winner = Nothing
    }
