module Decoders exposing (..)

import Json.Decode as JD exposing (succeed, int, string, float, list, Decoder, (:=), maybe, oneOf, bool)
import Json.Decode.Extra exposing ((|:))
import Home.Model exposing (..)
import Game.Model exposing (..)


homeModelDecoder : JD.Decoder Home.Model.Model
homeModelDecoder =
    succeed Home.Model.Model
        |: ("games" := (list gameDecoder))


gameDecoder : JD.Decoder Game.Model.Model
gameDecoder =
    succeed Game.Model.Model
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
