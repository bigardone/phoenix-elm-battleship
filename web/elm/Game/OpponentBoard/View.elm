module Game.OpponentBoard.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import Dict
import Game.Model exposing (..)
import Msg exposing (..)


view : Model -> Html Msg
view model =
    div
        [ id "opponents_board_container" ]
        [ header
            []
            [ h2
                []
                [ text "Shooting grid" ]
            ]
        , gridView model
        , remainingHitPointsView model
        ]


gridView : Model -> Html Msg
gridView model =
    let
        classes =
            classList [ ( "grid", True ) ]

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

        grid =
            case model.game.opponents_board of
                Just board ->
                    board.grid

                Nothing ->
                    Dict.fromList []

        rowCells =
            [0..9]
                |> List.map (\x -> gridCellView y x (Dict.get ((toString y) ++ (toString x)) grid))

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
            ]
            []


remainingHitPointsView : Model -> Html Msg
remainingHitPointsView model =
    let
        hitPoints =
            case model.game.opponents_board of
                Just board ->
                    board.hit_points

                Nothing ->
                    0
    in
        p
            []
            [ text ("Remaining hit points: " ++ (toString hitPoints)) ]
