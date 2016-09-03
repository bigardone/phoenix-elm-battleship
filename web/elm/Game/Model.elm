module Game.Model exposing (..)


type Orientation
    = Horizontal
    | Vertical


type alias Model =
    { game : Game
    , selectedShip : Ship
    , messages : List String
    , readyForBattle : Bool
    , gameOver : Bool
    , winnerId : Maybe String
    , currentTurn : Maybe String
    , error : Maybe String
    }


type alias GameResponse =
    { game : Game
    }


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


type alias Ship =
    { id : Maybe Int
    , size : Int
    , orientation : Orientation
    }


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
    { game = initialGame
    , selectedShip = (Ship Nothing 0 Horizontal)
    , messages = []
    , readyForBattle = False
    , gameOver = False
    , winnerId = Nothing
    , currentTurn = Nothing
    , error = Nothing
    }
