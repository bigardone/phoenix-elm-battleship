module Update exposing (..)

import String
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Decode as JD
import Json.Encode as JE
import Model exposing (..)
import Msg exposing (..)
import Decoders exposing (..)
import Navigation
import Routing exposing (toPath, Route(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ConnectSocket playerId ->
            { model | phoenixSocket = (initPhxSocket playerId) } ! []

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
                channelId =
                    "game:" ++ id

                channel =
                    Phoenix.Channel.init channelId
                        |> Phoenix.Channel.onJoin (always (GameData id))
                        |> Phoenix.Channel.onError (always NotFound)

                ( phoenixSocket, phxCmd ) =
                    model.phoenixSocket
                        |> Phoenix.Socket.on "game:player_joined" channelId PlayerJoined
                        |> Phoenix.Socket.on "game:message_sent" channelId ReceiveChatMessage
                        |> Phoenix.Socket.join channel
            in
                ( { model | phoenixSocket = phoenixSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        NavigateToHome ->
            ( model, Navigation.newUrl (toPath HomeIndexRoute) )

        NavigateToGame id ->
            ( model, Navigation.newUrl (toPath (GameShowRoute id)) )

        NotFound ->
            ( model, Navigation.newUrl (toPath NotFoundRoute) )

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
                    model ! []

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
                    model ! []

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
            case JD.decodeValue gameResponseDecoder raw of
                Ok gameResponseModel ->
                    let
                        modelGame =
                            model.game

                        responseGame =
                            gameResponseModel.game

                        newModelGame =
                            { modelGame | game = responseGame }
                    in
                        ( { model | game = newModelGame }
                        , Cmd.none
                        )

                Err error ->
                    ( model, Navigation.newUrl (toPath HomeIndexRoute) )

        PlayerJoined raw ->
            case JD.decodeValue playerJoinedResponseDecoder raw of
                Ok playerJoinedModel ->
                    let
                        modelGame =
                            model.game

                        game =
                            model.game.game

                        playerId =
                            playerJoinedModel.player_id

                        attackerId =
                            Maybe.withDefault "" game.attacker

                        defenderId =
                            Maybe.withDefault "" game.defender

                        newGame =
                            if String.length attackerId > 0 && String.contains attackerId playerId == False then
                                { game
                                    | defender = Just playerId
                                    , opponents_board = Just playerJoinedModel.board
                                }
                            else
                                game

                        newModelGame =
                            { modelGame | game = newGame }
                    in
                        ( { model | game = newModelGame }
                        , Cmd.none
                        )

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        model ! []

        SetMessageText text ->
            { model | messageText = text } ! []

        SendChatMessage ->
            let
                gameId =
                    Maybe.withDefault "" model.game.game.id

                payload =
                    JE.object [ ( "text", JE.string model.messageText ) ]

                push' =
                    Phoenix.Push.init "game:send_message" ("game:" ++ gameId)
                        |> Phoenix.Push.withPayload payload

                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.push push' model.phoenixSocket
            in
                ( { model | messageText = "", phoenixSocket = phoenixSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        ReceiveChatMessage raw ->
            case JD.decodeValue messageReceivedResponseDecoder raw of
                Ok chatMessage ->
                    let
                        game =
                            model.game

                        newGame =
                            { game | messages = game.messages ++ [ chatMessage.message ] }
                    in
                        ( { model | game = newGame }
                        , Cmd.none
                        )

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        model ! []

        PhoenixMsg msg ->
            let
                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phoenixSocket
            in
                ( { model | phoenixSocket = phoenixSocket }
                , Cmd.map PhoenixMsg phxCmd
                )


socketServer : String -> String
socketServer playerId =
    "ws://localhost:4000/socket/websocket?id=" ++ playerId


initPhxSocket : String -> Phoenix.Socket.Socket Msg
initPhxSocket playerId =
    socketServer playerId
        |> Phoenix.Socket.init
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.withHeartbeatInterval 60
        |> Phoenix.Socket.on "update_games" "lobby" ReceiveCurrentGames
