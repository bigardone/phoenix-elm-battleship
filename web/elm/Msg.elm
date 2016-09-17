module Msg exposing (..)

import Phoenix.Socket
import Json.Encode as JE
import Game.Model exposing (..)


type alias Flags =
    { playerId : String }


type Msg
    = NoOp
    | ConnectSocket String
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
    | SelectShip Ship
    | PlaceShip Int Int
    | SetGame JE.Value
    | SetError JE.Value
    | OpponentsBoardUpdate JE.Value
    | Shoot ( Int, Int )
    | GameOver JE.Value
    | ResetGame JE.Value
    | LeaveGameChannel String
    | PlayerLeft JE.Value
