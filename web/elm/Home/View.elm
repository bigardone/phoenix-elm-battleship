module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import Home.Model as HomeModel exposing (..)
import Game.Model as GameModel exposing (..)
import Msg exposing (..)
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
            []
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
                    statsView game
    in
        li
            []
            [ text (Maybe.withDefault "" game.id)
            , gameInfo
            ]


statsView : GameModel.Game -> Html Msg
statsView game =
    ul
        [ class "stats-list" ]
        [ lastTurnView game
        , winnerView game
        ]


lastTurnView : GameModel.Game -> Html Msg
lastTurnView game =
    if game.over then
        div [] []
    else
        case List.head game.turns of
            Nothing ->
                text ""

            Just turn ->
                let
                    turnPlayer =
                        turn.player_id

                    player =
                        if turnPlayer == Maybe.withDefault "" game.attacker then
                            "Attacker"
                        else
                            "Defender"

                    letters =
                        [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j" ]
                            |> Array.fromList

                    coords =
                        (Maybe.withDefault "" (Array.get turn.y letters)) ++ (toString (turn.x + 1))

                    result =
                        if turn.result == "*" then
                            "a ship"
                        else
                            "water"
                in
                    li
                        []
                        [ text (player ++ " shoots " ++ coords ++ " hitting " ++ result) ]


winnerView : GameModel.Game -> Html Msg
winnerView game =
    if (List.length game.turns > 0) && game.over then
        let
            player =
                if game.winner == game.attacker then
                    "Attacker"
                else
                    "Defender"
        in
            li
                []
                [ text (player ++ " wins!") ]
    else
        div [] []


footerView : Html Msg
footerView =
    footer []
        [ p []
            [ text "crafted with ♥ by "
            , a [ href "http://codeloveandboards.com/", target "_blank" ]
                [ text "@bigardone" ]
            ]
        , p []
            [ a [ href "https://github.com/bigardone/phoenix-elm-battleship", target "_blank" ]
                [ i [ attribute "className" "fa fa-github" ]
                    []
                , text " source code"
                ]
            ]
        ]
