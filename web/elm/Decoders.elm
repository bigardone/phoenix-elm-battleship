module Decoders exposing (..)

import Json.Decode as JD exposing (succeed, int, string, float, list, Decoder, (:=), maybe, oneOf, bool, dict)
import Json.Decode.Extra exposing ((|:))
import Home.Model exposing (..)
import Game.Model exposing (..)


homeModelDecoder : JD.Decoder Home.Model.Model
homeModelDecoder =
    succeed Home.Model.Model
        |: ("games" := (list gameDecoder))


gameResponseDecoder : JD.Decoder Game.Model.GameResponse
gameResponseDecoder =
    succeed Game.Model.GameResponse
        |: ("game" := gameDecoder)


gameDecoder : JD.Decoder Game.Model.Game
gameDecoder =
    succeed Game.Model.Game
        |: (maybe ("id" := string))
        |: (maybe ("attacker" := string))
        |: (maybe ("defender" := string))
        |: ("turns" := (list turnDecoder))
        |: ("over" := bool)
        |: (maybe ("winner" := string))
        |: (maybe ("my_board" := boardDecoder))
        |: (maybe ("opponents_board" := boardDecoder))


turnDecoder : JD.Decoder Game.Model.Turn
turnDecoder =
    succeed Game.Model.Turn
        |: ("player_id" := string)
        |: ("x" := int)
        |: ("y" := int)
        |: ("result" := string)


gameIdDecoder : JD.Decoder Game.Model.GameId
gameIdDecoder =
    succeed Game.Model.GameId
        |: ("game_id" := string)


boardDecoder : JD.Decoder Game.Model.Board
boardDecoder =
    succeed Game.Model.Board
        |: ("player_id" := string)
        |: (maybe ("ships" := (list shipDecoder)))
        |: ("grid" := dict string)
        |: ("ready" := bool)
        |: ("hit_points" := int)


shipDecoder : JD.Decoder Game.Model.Ship
shipDecoder =
    succeed Game.Model.Ship
        |: (maybe ("id" := int))
        |: ("size" := int)
        |: ("orientation" := string)
        |: ("coordinates" := dict string)


playerJoinedResponseDecoder : JD.Decoder Game.Model.PlayerJoinedModel
playerJoinedResponseDecoder =
    succeed Game.Model.PlayerJoinedModel
        |: ("player_id" := string)
        |: ("board" := boardDecoder)


chatMessageDecoder : JD.Decoder Game.Model.ChatMessage
chatMessageDecoder =
    succeed Game.Model.ChatMessage
        |: ("player_id" := string)
        |: ("text" := string)


messageReceivedResponseDecoder : JD.Decoder Game.Model.MessageReceivedModel
messageReceivedResponseDecoder =
    succeed Game.Model.MessageReceivedModel
        |: ("message" := chatMessageDecoder)


errorResponseDecoder : JD.Decoder Game.Model.ErrorModel
errorResponseDecoder =
    succeed Game.Model.ErrorModel
        |: ("reason" := string)
