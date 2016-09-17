module Game.Helpers exposing (..)

import Game.Model exposing (..)


isReadyForBattle : Game.Model.Game -> Bool
isReadyForBattle game =
    case ( game.my_board, game.opponents_board ) of
        ( Just myBoard, Just opponentsBoard ) ->
            myBoard.ready && opponentsBoard.ready

        _ ->
            False


whoseTurnIs : Game.Model.Game -> Maybe String
whoseTurnIs game =
    if isReadyForBattle game then
        let
            gameTurns =
                game.turns

            lastTurn =
                List.head gameTurns

            attacker =
                Maybe.withDefault "" game.attacker

            defender =
                Maybe.withDefault "" game.defender
        in
            case lastTurn of
                Just turn ->
                    if turn.player_id == attacker then
                        Just defender
                    else
                        Just attacker

                Nothing ->
                    Just attacker
    else
        Nothing


is13 : Int -> Result String ()
is13 code =
    if code == 13 then
        Ok ()
    else
        Err "not the right code"


isBoardReady : Maybe Board -> Bool
isBoardReady board =
    case board of
        Just board ->
            board.ready

        Nothing ->
            False


isItPlayersTurn : Maybe String -> String -> Bool
isItPlayersTurn currentTurn playerId =
    Maybe.withDefault "" currentTurn == playerId
