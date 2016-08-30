module View exposing (..)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Routing exposing (..)
import Types exposing (..)
import Model exposing (..)
import Home.View exposing (..)


view : Model -> Html Msg
view model =
    section
        []
        [ div []
            [ page model ]
        ]


page : Model -> Html Msg
page model =
    case model.route of
        _ ->
            Home.View.view model
