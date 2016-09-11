module Game.Board.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
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
            headerGridView (toString y)

        rowCells =
            [0..9]
                |> List.map gridCellView

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


gridCellView : Int -> Html Msg
gridCellView x =
    let
        classes =
            classList [ ( "cell", True ) ]
    in
        div [ classes ] []
