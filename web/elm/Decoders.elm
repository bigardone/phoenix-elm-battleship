module Decoders exposing (..)

import Json.Decode as JD exposing (succeed, int, string, float, list, Decoder, (:=), maybe, oneOf, bool)
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
