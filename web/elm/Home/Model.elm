module Home.Model exposing (..)

import Game.Model as Game exposing (Model)


type alias Model =
    { games : List Game.Game }


initialModel : Model
initialModel =
    { games = [] }
