module Model exposing (..)

import Phoenix.Socket
import Types exposing (..)
import Routing


type alias Model =
    { phoenixSocket : Maybe (Phoenix.Socket.Socket Msg)
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { phoenixSocket = Nothing
    , route = route
    }
