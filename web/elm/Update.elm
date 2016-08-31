module Update exposing (..)

import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Decode as JD
import Json.Encode as JE
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
                        |> Phoenix.Channel.onJoin (always (FetchCurrentGames))

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

        FetchCurrentGames ->
            let
                push' =
                    Phoenix.Push.init "current_games" "lobby"
                        |> Phoenix.Push.onOk ReceiveCurrentGames

                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.push push' model.phoenixSocket
            in
                ( { model
                    | phoenixSocket = phoenixSocket
                  }
                , Cmd.map PhoenixMsg phxCmd
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
            let
                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phoenixSocket
            in
                ( { model | phoenixSocket = phoenixSocket }
                , Cmd.map PhoenixMsg phxCmd
                )


socketServer : String
socketServer =
    "ws://localhost:4000/socket/websocket"


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.withHeartbeatInterval 10
        |> Phoenix.Socket.on "update_games" "lobby" ReceiveCurrentGames
