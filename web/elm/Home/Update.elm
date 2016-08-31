module Home.Update exposing (..)

import Home.Types exposing (Msg(..))
import Home.Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            model ! []
