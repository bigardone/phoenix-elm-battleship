module Types exposing (..)

import Phoenix.Socket


type Msg
    = ConnectSocket
    | JoinLobbyChannel
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
