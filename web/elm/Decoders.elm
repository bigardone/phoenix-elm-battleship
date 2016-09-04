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
        |: ("grid" := gridDecoder)
        |: ("ready" := bool)
        |: ("hit_points" := int)


shipDecoder : JD.Decoder Game.Model.Ship
shipDecoder =
    succeed Game.Model.Ship
        |: (maybe ("id" := int))
        |: ("size" := int)
        |: ("orientation" := string)


gridDecoder : JD.Decoder Game.Model.Grid
gridDecoder =
    succeed Game.Model.Grid
        |: ("c00" := string)
        |: ("c01" := string)
        |: ("c02" := string)
        |: ("c03" := string)
        |: ("c04" := string)
        |: ("c05" := string)
        |: ("c06" := string)
        |: ("c07" := string)
        |: ("c08" := string)
        |: ("c09" := string)
        |: ("c10" := string)
        |: ("c11" := string)
        |: ("c12" := string)
        |: ("c13" := string)
        |: ("c14" := string)
        |: ("c15" := string)
        |: ("c16" := string)
        |: ("c17" := string)
        |: ("c18" := string)
        |: ("c19" := string)
        |: ("c20" := string)
        |: ("c21" := string)
        |: ("c22" := string)
        |: ("c23" := string)
        |: ("c24" := string)
        |: ("c25" := string)
        |: ("c26" := string)
        |: ("c27" := string)
        |: ("c28" := string)
        |: ("c29" := string)
        |: ("c30" := string)
        |: ("c31" := string)
        |: ("c32" := string)
        |: ("c33" := string)
        |: ("c34" := string)
        |: ("c35" := string)
        |: ("c36" := string)
        |: ("c37" := string)
        |: ("c38" := string)
        |: ("c39" := string)
        |: ("c40" := string)
        |: ("c41" := string)
        |: ("c42" := string)
        |: ("c43" := string)
        |: ("c44" := string)
        |: ("c45" := string)
        |: ("c46" := string)
        |: ("c47" := string)
        |: ("c48" := string)
        |: ("c49" := string)
        |: ("c50" := string)
        |: ("c51" := string)
        |: ("c52" := string)
        |: ("c53" := string)
        |: ("c54" := string)
        |: ("c55" := string)
        |: ("c56" := string)
        |: ("c57" := string)
        |: ("c58" := string)
        |: ("c59" := string)
        |: ("c60" := string)
        |: ("c61" := string)
        |: ("c62" := string)
        |: ("c63" := string)
        |: ("c64" := string)
        |: ("c65" := string)
        |: ("c66" := string)
        |: ("c67" := string)
        |: ("c68" := string)
        |: ("c69" := string)
        |: ("c70" := string)
        |: ("c71" := string)
        |: ("c72" := string)
        |: ("c73" := string)
        |: ("c74" := string)
        |: ("c75" := string)
        |: ("c76" := string)
        |: ("c77" := string)
        |: ("c78" := string)
        |: ("c79" := string)
        |: ("c80" := string)
        |: ("c81" := string)
        |: ("c82" := string)
        |: ("c83" := string)
        |: ("c84" := string)
        |: ("c85" := string)
        |: ("c86" := string)
        |: ("c87" := string)
        |: ("c88" := string)
        |: ("c89" := string)
        |: ("c90" := string)
        |: ("c91" := string)
        |: ("c92" := string)
        |: ("c93" := string)
        |: ("c94" := string)
        |: ("c95" := string)
        |: ("c96" := string)
        |: ("c97" := string)
        |: ("c98" := string)
        |: ("c99" := string)


playerJoinedResponseDecoder : JD.Decoder Game.Model.PlayerJoinedModel
playerJoinedResponseDecoder =
    succeed Game.Model.PlayerJoinedModel
        |: ("player_id" := string)
        |: ("board" := boardDecoder)
