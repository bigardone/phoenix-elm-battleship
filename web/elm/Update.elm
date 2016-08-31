module Update exposing (..)

import Phoenix.Socket
import Phoenix.Channel
import Json.Decode as JD
import Model exposing (..)
import Types exposing (..)
import Home.Update exposing (..)
import Decoders exposing (..)


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

        HomeMsg subMsg ->
            let
                ( updatedHome, cmd ) =
                    Home.Update.update subMsg model.home
            in
                ( { model | home = updatedHome }
                , Cmd.map HomeMsg cmd
                )

        ReceiveCurrentGames raw ->
            case JD.decodeValue homeModelDecoder raw of
                Ok homeModel ->
                    ( { model | home = homeModel }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        PhoenixMsg msg ->
            model ! []


socketServer : String
socketServer =
    "ws://localhost:4000/socket/websocket"


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.withHeartbeatInterval 10
        |> Phoenix.Socket.on "update_games" "lobby" ReceiveCurrentGames
