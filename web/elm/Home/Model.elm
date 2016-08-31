module Home.Model exposing (..)

import Game.Model as Game exposing (Model)


type alias Model =
    { games : List Game.Model }


initialModel : Model
initialModel =
    { games = [] }
