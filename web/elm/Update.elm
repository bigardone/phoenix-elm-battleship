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
import Navigation
import Routing exposing (toPath, Route(..))


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

        JoinGameChannel id ->
            let
                channel =
                    Phoenix.Channel.init ("game:" ++ id)
                        |> Phoenix.Channel.onJoin (always (GameData id))
                        |> Phoenix.Channel.onError (always NotFound)

                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.join channel model.phoenixSocket
            in
                ( { model | phoenixSocket = phoenixSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        Home ->
            ( model, Navigation.newUrl (toPath HomeIndexRoute) )

        NotFound ->
            ( model, Navigation.newUrl (toPath NotFoundRoute) )

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

        NewGame ->
            let
                push' =
                    Phoenix.Push.init "new_game" "lobby"
                        |> Phoenix.Push.onOk RedirectToGame

                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.push push' model.phoenixSocket
            in
                ( { model
                    | phoenixSocket = phoenixSocket
                  }
                , Cmd.map PhoenixMsg phxCmd
                )

        RedirectToGame raw ->
            case JD.decodeValue gameIdDecoder raw of
                Ok gameId ->
                    ( model, Navigation.newUrl (toPath (GameShowRoute gameId.game_id)) )

                Err error ->
                    ( model, Cmd.none )

        GameData id ->
            let
                push' =
                    Phoenix.Push.init "game:get_data" ("game:" ++ id)
                        |> Phoenix.Push.onOk ReceiveGameData

                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.push push' model.phoenixSocket
            in
                ( { model | phoenixSocket = phoenixSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        ReceiveGameData raw ->
            case JD.decodeValue gameModelDecoder raw of
                Ok gameModel ->
                    ( { model | game = gameModel }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Navigation.newUrl (toPath HomeIndexRoute) )

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
