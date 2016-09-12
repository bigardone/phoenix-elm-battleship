module Game.Model exposing (..)

import Dict


type alias Model =
    { game : Game
    , selectedShip : Ship
    , messages : List ChatMessage
    , readyForBattle : Bool
    , gameOver : Bool
    , winnerId : Maybe String
    , currentTurn : Maybe String
    , error : Maybe String
    }


type alias GameResponse =
    { game : Game
    }


type alias PlayerJoinedModel =
    { player_id : String
    , board : Board
    }


type alias Game =
    { id : Maybe String
    , attacker : Maybe String
    , defender : Maybe String
    , turns : List Turn
    , over : Bool
    , winner : Maybe String
    , my_board : Maybe Board
    , opponents_board : Maybe Board
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
    , orientation : String
    , coordinates : Maybe Coordinates
    }


type alias Coordinates =
    { x : Int
    , y : Int
    }


type alias Board =
    { player_id : String
    , ships : Maybe (List Ship)
    , grid : Dict.Dict String String
    , ready : Bool
    , hit_points : Int
    }


type alias ChatMessage =
    { player_id : String
    , text : String
    }


type alias MessageReceivedModel =
    { message : ChatMessage }


type alias ErrorModel =
    { reason : String }


initialGame : Game
initialGame =
    { id = Nothing
    , attacker = Nothing
    , defender = Nothing
    , turns = []
    , over = False
    , winner = Nothing
    , my_board = Nothing
    , opponents_board = Nothing
    }


initialShip : Ship
initialShip =
    Ship Nothing 0 "vertical" Nothing


initialModel : Model
initialModel =
    { game = initialGame
    , selectedShip = initialShip
    , messages = []
    , readyForBattle = False
    , gameOver = False
    , winnerId = Nothing
    , currentTurn = Nothing
    , error = Nothing
    }
