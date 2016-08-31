module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Home.Model as HomeModel exposing (..)
import Game.Model as GameModel exposing (..)
import Types exposing (..)
import Logo.View as LogoView


view : HomeModel.Model -> Html Msg
view model =
    div
        [ id "home_index"
        , class "view-container"
        ]
        [ headerView
        , currentGames model
        , footerView
        ]


headerView : Html Msg
headerView =
    header
        []
        [ LogoView.view
        , h1
            []
            [ text "Ahoy Matey, "
            , br [] []
            , text "welcome to Phoenix Battleship!"
            ]
        , p []
            [ text "The "
            , a [ href "https://en.wikipedia.org/wiki/Battleship_(game)", target "_blank" ]
                [ text "Good Old game" ]
            , text ", built with "
            , a [ href "http://elixir-lang.org/", target "_blank" ]
                [ text "Elixir" ]
            , text ", "
            , a [ href "http://www.phoenixframework.org/", target "_blank" ]
                [ text "Phoenix" ]
            , text " and "
            , a [ href "http://elm-lang.org/", target "_blank" ]
                [ text "Elm" ]
            ]
        , button
            [ onClick NewGame ]
            [ text "Start new battle, arr!" ]
        ]


currentGames : HomeModel.Model -> Html Msg
currentGames model =
    if List.length model.games == 0 then
        section
            []
            [ text "No games" ]
    else
        section
            []
            [ h2
                []
                [ text "Current games" ]
            , model.games
                |> List.map gameView
                |> ul
                    [ attribute "class" "current-games" ]
            ]


gameView : GameModel.Game -> Html Msg
gameView game =
    let
        gameInfo =
            case game.defender of
                Nothing ->
                    (a
                        [ class "button small"
                        , onClick (NavigateToGame (Maybe.withDefault "" game.id))
                        ]
                        [ text "join" ]
                    )

                Just defender ->
                    lastTurnView game
    in
        li
            []
            [ text (Maybe.withDefault "" game.id)
            , gameInfo
            ]


lastTurnView : GameModel.Game -> Html Msg
lastTurnView game =
    case List.head game.turns of
        Nothing ->
            text ""

        Just turn ->
            ul
                [ class "stats-list" ]
                []


footerView : Html Msg
footerView =
    footer []
        [ p []
            [ text "crafted with ♥ by "
            , a [ href "http://codeloveandboards.com/", target "_blank" ]
                [ text "@bigardone" ]
            ]
        , p []
            [ a [ href "https://github.com/bigardone/phoenix-battleship", target "_blank" ]
                [ i [ attribute "className" "fa fa-github" ]
                    []
                , text " source code"
                ]
            ]
        ]
