module Game.Model exposing (..)


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
    , grid : Grid
    , ready : Bool
    , hit_points : Int
    }


type alias Grid =
    { c00 : String
    , c01 : String
    , c02 : String
    , c03 : String
    , c04 : String
    , c05 : String
    , c06 : String
    , c07 : String
    , c08 : String
    , c09 : String
    , c10 : String
    , c11 : String
    , c12 : String
    , c13 : String
    , c14 : String
    , c15 : String
    , c16 : String
    , c17 : String
    , c18 : String
    , c19 : String
    , c20 : String
    , c21 : String
    , c22 : String
    , c23 : String
    , c24 : String
    , c25 : String
    , c26 : String
    , c27 : String
    , c28 : String
    , c29 : String
    , c30 : String
    , c31 : String
    , c32 : String
    , c33 : String
    , c34 : String
    , c35 : String
    , c36 : String
    , c37 : String
    , c38 : String
    , c39 : String
    , c40 : String
    , c41 : String
    , c42 : String
    , c43 : String
    , c44 : String
    , c45 : String
    , c46 : String
    , c47 : String
    , c48 : String
    , c49 : String
    , c50 : String
    , c51 : String
    , c52 : String
    , c53 : String
    , c54 : String
    , c55 : String
    , c56 : String
    , c57 : String
    , c58 : String
    , c59 : String
    , c60 : String
    , c61 : String
    , c62 : String
    , c63 : String
    , c64 : String
    , c65 : String
    , c66 : String
    , c67 : String
    , c68 : String
    , c69 : String
    , c70 : String
    , c71 : String
    , c72 : String
    , c73 : String
    , c74 : String
    , c75 : String
    , c76 : String
    , c77 : String
    , c78 : String
    , c79 : String
    , c80 : String
    , c81 : String
    , c82 : String
    , c83 : String
    , c84 : String
    , c85 : String
    , c86 : String
    , c87 : String
    , c88 : String
    , c89 : String
    , c90 : String
    , c91 : String
    , c92 : String
    , c93 : String
    , c94 : String
    , c95 : String
    , c96 : String
    , c97 : String
    , c98 : String
    , c99 : String
    }


type alias ChatMessage =
    { player_id : String
    , text : String
    }


type alias MessageReceivedModel =
    { message : ChatMessage }


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


initialModel : Model
initialModel =
    { game = initialGame
    , selectedShip = (Ship Nothing 0 "horizontal" Nothing)
    , messages = []
    , readyForBattle = False
    , gameOver = False
    , winnerId = Nothing
    , currentTurn = Nothing
    , error = Nothing
    }
