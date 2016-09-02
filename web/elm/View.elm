module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Routing exposing (..)
import Types exposing (..)
import Model exposing (..)
import Home.View exposing (..)
import Game.View exposing (..)
import Logo.View as LogoView


view : Model -> Html Msg
view model =
    page model


page : Model -> Html Msg
page model =
    case model.route of
        GameShowRoute id ->
            Game.View.view model.game

        NotFoundRoute ->
            notFoundView

        _ ->
            Home.View.view model.home


notFoundView : Html Msg
notFoundView =
    div
        [ id "not_found"
        , class "view-container"
        ]
        [ LogoView.view
        , h1
            []
            [ text "Yo Ho Ho, game not found!" ]
        , button
            [ onClick NewGame ]
            [ text "Start new battle, arr!" ]
        , p
            []
            [ a
                [ onClick NavigateToHome ]
                [ text "Back to home" ]
            ]
        ]
