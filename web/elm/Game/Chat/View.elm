module Game.Chat.View exposing (..)

import Html exposing (..)
import Json.Decode as JD
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Game.Model exposing (..)
import Msg exposing (..)
import Game.Helpers exposing (..)


view : String -> String -> Model -> Html Msg
view playerId messageText model =
    let
        opponentIsConnected =
            case ( model.game.attacker, model.game.defender ) of
                ( Just attackerId, Just defenderId ) ->
                    True

                _ ->
                    False

        statusText =
            if opponentIsConnected == True then
                "Opponent is connected"
            else
                "No opponnent yet connected"

        classes =
            classList [ ( "status", True ), ( "connected", opponentIsConnected ) ]
    in
        aside
            [ id "chat_container" ]
            [ header
                []
                [ p
                    []
                    [ i [ classes ] []
                    , text statusText
                    ]
                ]
            , div
                [ class "messages-container" ]
                [ model.messages
                    |> List.map (messageView playerId)
                    |> ul []
                ]
            , div
                [ class "form-container" ]
                [ div [ class "form-container" ]
                    [ input
                        [ disabled (not opponentIsConnected)
                        , autofocus True
                        , onInput SetMessageText
                        , on "keypress" handleKeyPress
                        , placeholder "Type message and hit intro..."
                        , value messageText
                        ]
                        []
                    ]
                ]
            ]


messageView : String -> ChatMessage -> Html Msg
messageView playerId message =
    let
        classes =
            classList [ ( "mine", message.player_id == playerId ) ]
    in
        li
            [ classes ]
            [ span [] [ text message.text ] ]


handleKeyPress : JD.Decoder Msg
handleKeyPress =
    JD.map (always (SendChatMessage)) (JD.customDecoder keyCode is13)
