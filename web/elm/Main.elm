module Main exposing (..)

import Phoenix.Socket
import Navigation
import View exposing (view)
import Model exposing (..)
import Home.Model as HomeModel
import Game.Model as GameModel
import Update exposing (..)
import Types exposing (Msg(..), Flags)
import Routing exposing (..)


init : Flags -> Result String Route -> ( Model, Cmd Msg )
init flags result =
    let
        currentRoute =
            Routing.routeFromResult result

        model =
            initialModel flags.playerId currentRoute
    in
        urlUpdate result model


initialModel : String -> Routing.Route -> Model
initialModel playerId route =
    { playerId = playerId
    , phoenixSocket = (initPhxSocket playerId)
    , connectedToLobby = False
    , route = route
    , home = HomeModel.initialModel
    , game = GameModel.initialModel
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phoenixSocket PhoenixMsg


urlUpdate : Result String Route -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    let
        currentRoute =
            Routing.routeFromResult result
    in
        case currentRoute of
            HomeIndexRoute ->
                let
                    ( updatedModel, cmd ) =
                        update JoinLobbyChannel model
                in
                    ( { updatedModel | route = currentRoute, connectedToLobby = True }, cmd )

            GameShowRoute id ->
                let
                    ( updatedModel, cmd ) =
                        update (JoinGameChannel id) model
                in
                    ( { updatedModel | route = currentRoute }, cmd )

            _ ->
                ( { model | route = currentRoute }, Cmd.none )


main : Program Flags
main =
    Navigation.programWithFlags Routing.parser
        { init = init
        , view = view
        , update = update
        , urlUpdate = urlUpdate
        , subscriptions = subscriptions
        }
