module Game.Model exposing (..)


type alias Model =
    { game : Game }


type alias Game =
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


type alias GameId =
    { game_id : String }


initialGame : Game
initialGame =
    { id = Nothing
    , attacker = Nothing
    , defender = Nothing
    , turns = []
    , over = False
    , winner = Nothing
    }


initialModel : Model
initialModel =
    { game = initialGame }
