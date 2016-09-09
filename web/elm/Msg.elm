module Msg exposing (..)

import Phoenix.Socket
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
    | FetchCurrentGames
    | ReceiveCurrentGames JE.Value
    | NewGame
    | RedirectToGame JE.Value
    | GameData String
    | ReceiveGameData JE.Value
    | PlayerJoined JE.Value
    | SetMessageText String
    | SendChatMessage
    | ReceiveChatMessage JE.Value
