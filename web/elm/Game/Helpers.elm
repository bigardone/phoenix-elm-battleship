module Game.Helpers exposing (..)

import Game.Model exposing (..)


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
