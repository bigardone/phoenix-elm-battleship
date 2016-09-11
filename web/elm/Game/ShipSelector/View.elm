module Game.ShipSelector.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Game.Model exposing (..)
import Msg exposing (..)


shipSelectorView : Model -> Html Msg
shipSelectorView model =
    let
        orientation =
            model.selectedShip.orientation

        myShips =
            case model.game.my_board of
                Just myBoard ->
                    case myBoard.ships of
                        Just ships ->
                            ships
                                |> List.indexedMap (,)

                        Nothing ->
                            []

                Nothing ->
                    []
    in
        div
            [ id "ship_selector" ]
            [ p
                []
                [ text "The current orientation is: "
                , span
                    [ class "orientation" ]
                    [ text orientation ]
                ]
            , myShips
                |> List.map (\( shipId, ship ) -> shipSelectorShip model.selectedShip (shipId + 1) ship)
                |> ul []
            ]


shipSelectorShip : Ship -> Int -> Ship -> Html Msg
shipSelectorShip selectedShip shipId ship =
    case ship.coordinates of
        Just coordinates ->
            div [] []

        Nothing ->
            let
                newShip =
                    { ship | id = Just shipId }

                nodes =
                    [1..ship.size]
                        |> List.map (\i -> span [] [])
                        |> div
                            [ class "ship"
                            , onClick (SelectShip newShip)
                            ]

                classes =
                    classList [ ( "active", (shipId == (Maybe.withDefault 0 selectedShip.id)) ) ]
            in
                li
                    [ classes ]
                    [ nodes ]
