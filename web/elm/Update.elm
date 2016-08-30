module Update exposing (..)

import Phoenix.Socket
import Model exposing (..)
import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ConnectSocket ->
            { model | phoenixSocket = Just initPhxSocket } ! []

        PhoenixMsg msg ->
            model ! []


socketServer : String
socketServer =
    "ws://localhost:4000/socket/websocket"


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
