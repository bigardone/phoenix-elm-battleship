module Game.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Game.Model exposing (..)
import Msg exposing (..)
import Game.Instructions.View as InstructionsView
import Game.MyBoard.View as MyBoardView
import Game.OpponentBoard.View as OpponentBoardView
import Game.Result.View as ResultView
import Game.Chat.View as ChatView
import Game.Helpers exposing (..)


view : String -> String -> String -> Model -> Html Msg
view playerId messageText baseUrl model =
    case model.game.id of
        Just gameId ->
            div
                [ id "game_show"
                , class "view-container"
                ]
                [ gameContent playerId baseUrl model
                , ChatView.view playerId messageText model
                ]

        Nothing ->
            div [] []


gameContent : String -> String -> Model -> Html Msg
gameContent playerId baseUrl model =
    if model.gameOver then
        ResultView.view playerId model
    else
        gameView playerId baseUrl model


gameView : String -> String -> Model -> Html Msg
gameView playerId baseUrl model =
    section
        [ id "main_section" ]
        [ headerView playerId model
        , section
            [ id "boards_container" ]
            [ MyBoardView.view model
            , opponentBoard playerId baseUrl model
            ]
        ]


headerView : String -> Model -> Html Msg
headerView playerId model =
    let
        ( title, message ) =
            if isBoardReady model.game.my_board == False then
                ( "Place your ships", "Use the instructions below" )
            else if isBoardReady model.game.opponents_board == False then
                ( "Waiting for opponent", "Battle will start as soon as your opponent is ready" )
            else if isItPlayersTurn model.currentTurn playerId then
                ( "Your turn!", "Click on your shooting grid to open fire!" )
            else if not (isItPlayersTurn model.currentTurn playerId) then
                ( "Your opponent's turn!", "Wait for your opponent to shoot..." )
            else
                ( "Let the battle begin", "Let the battle begin" )
    in
        header
            [ id "game_header" ]
            [ h1 [] [ text title ]
            , p [] [ text message ]
            ]


opponentBoard : String -> String -> Model -> Html Msg
opponentBoard playerId baseUrl model =
    if model.readyForBattle == False then
        InstructionsView.view playerId baseUrl model
    else
        OpponentBoardView.view playerId model
