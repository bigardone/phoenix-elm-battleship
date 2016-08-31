module Types exposing (..)

import Phoenix.Socket
import Home.Types exposing (..)
import Json.Encode as JE


type Msg
    = ConnectSocket
    | JoinLobbyChannel
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | HomeMsg Home.Types.Msg
    | ReceiveCurrentGames JE.Value
