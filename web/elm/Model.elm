module Model exposing (..)

import Phoenix.Socket
import Types exposing (..)
import Routing
import Home.Model as HomeModel
import Game.Model as GameModel


type alias Model =
    { phoenixSocket : Phoenix.Socket.Socket Msg
    , route : Routing.Route
    , home : HomeModel.Model
    , game : GameModel.Model
    }
