module Home.Model exposing (..)

import Game.Model as Game exposing (Model)


type alias Model =
    { currentGames : List Game.Model }


initialModel : Model
initialModel =
    { currentGames = [] }
