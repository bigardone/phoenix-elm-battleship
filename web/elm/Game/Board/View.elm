module Game.Board.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import Dict
import Game.Model exposing (..)
import Msg exposing (..)
import Game.ShipSelector.View exposing (..)


myBoardView : Model -> Html Msg
myBoardView model =
    div
        [ id "my_board_container" ]
        [ header
            []
            [ h2 []
                [ text "Your ships" ]
            ]
        , shipSelectorView model
        , gridView model
        , errorView model
        ]


gridView : Model -> Html Msg
gridView model =
    let
        classes =
            classList [ ( "grid", True ), ( "pointer", model.selectedShip.id /= Nothing ) ]

        gridRows =
            [0..9]
                |> List.map (\y -> gridRowView model y)

        rows =
            headerRowView :: gridRows
    in
        rows
            |> List.map (\row -> row)
            |> div
                [ classes ]


headerRowView : Html Msg
headerRowView =
    let
        letters =
            [ "", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j" ]
                |> Array.fromList
    in
        [0..10]
            |> List.map (\value -> headerGridView (Maybe.withDefault "" (Array.get value letters)))
            |> div [ class "row" ]


gridRowView : Model -> Int -> Html Msg
gridRowView model y =
    let
        headerCell =
            headerGridView (toString (y + 1))

        myBoardGrid =
            case model.game.my_board of
                Just board ->
                    board.grid

                Nothing ->
                    Dict.fromList []

        rowCells =
            [0..9]
                |> List.map (\x -> gridCellView y x (Dict.get ((toString y) ++ (toString x)) myBoardGrid))

        cells =
            headerCell :: rowCells
    in
        cells
            |> List.map (\cell -> cell)
            |> div
                [ class "row" ]


headerGridView : String -> Html Msg
headerGridView value =
    div
        [ class "header cell" ]
        [ text value ]


gridCellView : Int -> Int -> Maybe String -> Html Msg
gridCellView y x maybeValue =
    let
        value =
            Maybe.withDefault "" maybeValue

        classes =
            classList
                [ ( "cell", True )
                , ( "ship", value == "/" )
                , ( "ship-hit", value == "O" )
                , ( "water-ship", value == "*" )
                ]
    in
        div
            [ classes
            , onClick (PlaceShip y x)
            ]
            []


errorView : Model -> Html Msg
errorView model =
    case model.error of
        Nothing ->
            div [] []

        Just error ->
            div
                [ class "error" ]
                [ text error ]
