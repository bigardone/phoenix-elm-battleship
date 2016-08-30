module Types exposing (..)

import Phoenix.Socket


type Msg
    = NoOp
    | ConnectSocket
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
