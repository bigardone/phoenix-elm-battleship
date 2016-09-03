module Types exposing (..)

import Phoenix.Socket
import Home.Types exposing (..)
import Json.Encode as JE


type alias Flags =
    { playerId : String }


type Msg
    = ConnectSocket String
    | JoinLobbyChannel
    | JoinGameChannel String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | NavigateToHome
    | NavigateToGame String
    | NotFound
    | HomeMsg Home.Types.Msg
    | FetchCurrentGames
    | ReceiveCurrentGames JE.Value
    | NewGame
    | RedirectToGame JE.Value
    | GameData String
    | ReceiveGameData JE.Value
