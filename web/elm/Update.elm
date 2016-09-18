module Update exposing (..)

import String
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Decode as JD
import Json.Encode as JE
import Model exposing (..)
import Game.Model exposing (initialShip)
import Msg exposing (..)
import Decoders exposing (..)
import Navigation
import Routing exposing (toPath, Route(..))
import Game.Helpers exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

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

                playerId =
                    model.playerId

                ( phoenixSocket, phxCmd ) =
                    model.phoenixSocket
                        |> Phoenix.Socket.on "game:player_joined" channelId PlayerJoined
                        |> Phoenix.Socket.on "game:message_sent" channelId ReceiveChatMessage
                        |> Phoenix.Socket.on "game:over" channelId GameOver
                        |> Phoenix.Socket.on "game:stopped" channelId ResetGame
                        |> Phoenix.Socket.on "game:player_left" channelId PlayerLeft
                        |> Phoenix.Socket.on ("game:player:" ++ playerId ++ ":opponents_board_changed") channelId OpponentsBoardUpdate
                        |> Phoenix.Socket.on ("game:player:" ++ playerId ++ ":set_game") channelId SetGame
                        |> Phoenix.Socket.join channel
            in
                ( { model
                    | phoenixSocket = phoenixSocket
                    , game = Game.Model.initialModel
                  }
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
                    { model | home = homeModel } ! []

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
                        { model | game = newModelGame } ! []

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
                        { model | game = newModelGame } ! []

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
                        { model | game = newGame } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        model ! []

        SelectShip ship ->
            let
                game =
                    model.game

                shipId =
                    ship.id

                selectedShip =
                    game.selectedShip

                newShip =
                    case ( shipId == selectedShip.id, selectedShip.orientation ) of
                        ( True, "vertical" ) ->
                            { ship | orientation = "horizontal" }

                        ( True, "horizontal" ) ->
                            { ship | orientation = "vertical" }

                        _ ->
                            { ship | orientation = "horizontal" }

                newGame =
                    { game | selectedShip = newShip }
            in
                { model | game = newGame } ! []

        PlaceShip y x ->
            let
                ship =
                    model.game.selectedShip
            in
                case ship.id of
                    Nothing ->
                        model ! []

                    Just shipId ->
                        let
                            gameId =
                                Maybe.withDefault "" model.game.game.id

                            selectedShip =
                                model.game.selectedShip

                            encodedShip =
                                JE.object
                                    [ ( "y", JE.int y )
                                    , ( "x", JE.int x )
                                    , ( "size", JE.int selectedShip.size )
                                    , ( "orientation", JE.string selectedShip.orientation )
                                    ]

                            payload =
                                JE.object [ ( "ship", encodedShip ) ]

                            push' =
                                Phoenix.Push.init "game:place_ship" ("game:" ++ gameId)
                                    |> Phoenix.Push.onOk SetGame
                                    |> Phoenix.Push.onError SetError
                                    |> Phoenix.Push.withPayload payload

                            ( phoenixSocket, phxCmd ) =
                                Phoenix.Socket.push push' model.phoenixSocket
                        in
                            ( { model | messageText = "", phoenixSocket = phoenixSocket }
                            , Cmd.map PhoenixMsg phxCmd
                            )

        SetGame raw ->
            case JD.decodeValue gameResponseDecoder raw of
                Ok game ->
                    let
                        modelGame =
                            model.game

                        modelGameGame =
                            modelGame.game

                        newModelGameGame =
                            game.game

                        readyForBattle =
                            isReadyForBattle newModelGameGame

                        currentTurn =
                            whoseTurnIs newModelGameGame

                        newModelGame =
                            { modelGame
                                | game = newModelGameGame
                                , readyForBattle = readyForBattle
                                , currentTurn = currentTurn
                                , selectedShip = initialShip
                                , error = Nothing
                            }
                    in
                        { model | game = newModelGame } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        model ! []

        SetError raw ->
            case JD.decodeValue errorResponseDecoder raw of
                Ok error ->
                    let
                        modelGame =
                            model.game

                        newModelGame =
                            { modelGame | error = Just error.reason }
                    in
                        { model | game = newModelGame } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        model ! []

        OpponentsBoardUpdate raw ->
            case JD.decodeValue opponentsBoardUpdatedResponseDecoder raw of
                Ok opponentsBoard ->
                    let
                        modelGame =
                            model.game

                        modelGameGame =
                            modelGame.game

                        newModelGameGame =
                            { modelGameGame | opponents_board = Just opponentsBoard.board }

                        readyForBattle =
                            isReadyForBattle newModelGameGame

                        currentTurn =
                            whoseTurnIs newModelGameGame

                        newModelGame =
                            { modelGame
                                | game = newModelGameGame
                                , readyForBattle = readyForBattle
                                , currentTurn = currentTurn
                            }
                    in
                        { model | game = newModelGame } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        model ! []

        Shoot ( y, x ) ->
            if isItPlayersTurn model.game.currentTurn model.playerId then
                let
                    gameId =
                        Maybe.withDefault "" model.game.game.id

                    payload =
                        JE.object
                            [ ( "y", JE.int y )
                            , ( "x", JE.int x )
                            ]

                    push' =
                        Phoenix.Push.init "game:shoot" ("game:" ++ gameId)
                            |> Phoenix.Push.onOk SetGame
                            |> Phoenix.Push.withPayload payload

                    ( phoenixSocket, phxCmd ) =
                        Phoenix.Socket.push push' model.phoenixSocket
                in
                    ( { model | phoenixSocket = phoenixSocket }
                    , Cmd.map PhoenixMsg phxCmd
                    )
            else
                model ! []

        GameOver raw ->
            case JD.decodeValue gameResponseDecoder raw of
                Ok response ->
                    let
                        modelGame =
                            model.game

                        newModelGame =
                            if modelGame.gameOver then
                                { modelGame | game = response.game }
                            else
                                { modelGame
                                    | game = response.game
                                    , winnerId = response.game.winner
                                    , gameOver = True
                                }
                    in
                        { model | game = newModelGame } ! []

                Err error ->
                    let
                        _ =
                            Debug.log "error" error
                    in
                        model ! []

        ResetGame raw ->
            let
                gameId =
                    Maybe.withDefault "" model.game.game.id

                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.leave ("game:" ++ gameId) model.phoenixSocket

                newModel =
                    { model
                        | phoenixSocket = phoenixSocket
                        , game = Game.Model.initialModel
                    }
            in
                ( newModel, Navigation.newUrl (toPath GameErrorRoute) )

        LeaveGameChannel gameId ->
            let
                ( phoenixSocket, phxCmd ) =
                    Phoenix.Socket.leave ("game:" ++ gameId) model.phoenixSocket
            in
                ( { model
                    | phoenixSocket = phoenixSocket
                    , game = Game.Model.initialModel
                  }
                , Cmd.map PhoenixMsg phxCmd
                )

        PlayerLeft raw ->
            case JD.decodeValue playerLeftResponseDecoder raw of
                Ok response ->
                    let
                        modelGame =
                            model.game

                        modelGameGame =
                            modelGame.game

                        newModelGameGame =
                            if (Maybe.withDefault "" modelGameGame.attacker) == response.player_id then
                                { modelGameGame | attacker = Nothing }
                            else
                                { modelGameGame | defender = Nothing }

                        newModelGame =
                            { modelGame | game = newModelGameGame }
                    in
                        { model | game = newModelGame } ! []

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
    "wss://phoenix-elm-battleship.herokuapp.com/socket/websocket?id=" ++ playerId


initPhxSocket : String -> Phoenix.Socket.Socket Msg
initPhxSocket playerId =
    socketServer playerId
        |> Phoenix.Socket.init
        |> Phoenix.Socket.withHeartbeatInterval 60
        |> Phoenix.Socket.on "update_games" "lobby" ReceiveCurrentGames
