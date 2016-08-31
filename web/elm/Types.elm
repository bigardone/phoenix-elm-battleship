module Types exposing (..)

import Phoenix.Socket
import Home.Types exposing (..)
import Json.Encode as JE


type Msg
    = ConnectSocket
    | JoinLobbyChannel
    | JoinGameChannel String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | Home
    | NotFound
    | HomeMsg Home.Types.Msg
    | FetchCurrentGames
    | ReceiveCurrentGames JE.Value
    | NewGame
    | RedirectToGame JE.Value
    | GameData String
    | ReceiveGameData JE.Value
