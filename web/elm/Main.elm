module Main exposing (..)

import Phoenix.Socket
import Navigation
import View exposing (view)
import Model exposing (..)
import Home.Model as HomeModel
import Game.Model as GameModel
import Update exposing (..)
import Msg exposing (Msg(..), Flags)
import Routing exposing (..)
import Ports exposing (..)


init : Flags -> Result String Route -> ( Model, Cmd Msg )
init flags result =
    let
        currentRoute =
            Routing.routeFromResult result

        model =
            initialModel flags.playerId flags.baseUrl currentRoute
    in
        urlUpdate result model


initialModel : String -> String -> Routing.Route -> Model
initialModel playerId baseUrl route =
    { playerId = playerId
    , baseUrl = baseUrl
    , phoenixSocket = (initPhxSocket playerId)
    , connectedToLobby = False
    , route = route
    , home = HomeModel.initialModel
    , game = GameModel.initialModel
    , messageText = ""
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phoenixSocket PhoenixMsg


urlUpdate : Result String Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result

        ( updatedModel, joinGameChannelCmd ) =
            update JoinLobbyChannel model

        title =
            routeTitle currentRoute

        commands =
            [ joinGameChannelCmd, setDocumentTitle title ]
    in
        case currentRoute of
            GameShowRoute id ->
                let
                    ( updatedModel2, cmd2 ) =
                        update (JoinGameChannel id) updatedModel

                    commands =
                        cmd2 :: commands
                in
                    ( { updatedModel2 | route = currentRoute }, Cmd.batch <| List.reverse commands )

            _ ->
                let
                    ( updatedModel2, cmd2 ) =
                        case model.route of
                            GameShowRoute id ->
                                update (LeaveGameChannel id) model

                            _ ->
                                ( updatedModel, Cmd.none )

                    commands =
                        cmd2 :: commands
                in
                    ( { updatedModel | route = currentRoute, connectedToLobby = True }, Cmd.batch <| List.reverse commands )


main : Program Flags
main =
    Navigation.programWithFlags Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
