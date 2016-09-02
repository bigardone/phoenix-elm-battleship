module Game.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Game.Model exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div
        [ id "game_show"
        , class "view-container"
        ]
        [ gameContent model ]


gameContent : Model -> Html Msg
gameContent model =
    if model.game.over == False then
        gameView model
    else
        resultView model


gameView : Model -> Html Msg
gameView model =
    section
        [ id "main_section" ]
        [ headerView model
        , section
            [ id "boards_container" ]
            [ myBoardView model
            , opponentBoard model
            ]
        ]


headerView : Model -> Html Msg
headerView model =
    header
        [ id "game_header" ]
        [ h1 [] [ text "title" ]
        , p [] [ text "message" ]
        ]


resultView : Model -> Html Msg
resultView model =
    div [] []


myBoardView : Model -> Html Msg
myBoardView model =
    div
        [ id "my_board_container" ]
        [ header
            []
            [ h2 []
                [ text "Your ships" ]
            ]
        ]


opponentBoard : Model -> Html Msg
opponentBoard model =
    if model.readyForBattle == False then
        instructionsView model
    else
        div
            [ id "opponents_board_container" ]
            [ header
                []
                [ h2 [] [ text "Shooting grid" ] ]
            ]


instructionsView : Model -> Html Msg
instructionsView model =
    div [ id "opponents_board_container" ]
        [ header
            []
            [ h2 [] [ text "Instructions" ]
            ]
        , ol [ class "instructions" ]
            [ li []
                [ text "To place a ship in your board select one by clicking on the gray boxes." ]
            , li []
                [ text "The selected ship will turn green." ]
            , li []
                [ text "Switch the orientation of the ship by clicking again on it." ]
            , li []
                [ text "To place the selected ship click on the cell where you want it to start." ]
            , li []
                [ text "Repeat the process until you place all your ships." ]
            , li []
                [ text "Tha battle will start as soon as both players have placed all their ships." ]
            , li []
                [ text "Good luck!" ]
            ]
        ]
