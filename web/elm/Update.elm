module Update exposing (..)

import Phoenix.Socket
import Phoenix.Channel
import Model exposing (..)
import Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ConnectSocket ->
            { model | phoenixSocket = initPhxSocket } ! []

        JoinLobbyChannel ->
            let
                channel =
                    Phoenix.Channel.init "lobby"

                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.join channel model.phoenixSocket
            in
                ( { model | phoenixSocket = phoenixSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        PhoenixMsg msg ->
            model ! []


socketServer : String
socketServer =
    "ws://localhost:4000/socket/websocket"


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
