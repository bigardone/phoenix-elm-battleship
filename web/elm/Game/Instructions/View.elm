module Game.Instructions.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Game.Model exposing (..)
import Msg exposing (..)


view : String -> String -> Model -> Html Msg
view playerId baseUrl model =
    let
        firstStep =
            if Maybe.withDefault "" model.game.attacker == playerId then
                li []
                    [ text "Copy this link and share it with your opponent."
                    , br []
                        []
                    , input
                        [ readonly True
                        , value (baseUrl ++ "/game/" ++ (Maybe.withDefault "" model.game.id))
                        ]
                        []
                    ]
            else
                span [] []
    in
        div [ id "instructions_container" ]
            [ header
                []
                [ h2 [] [ text "Instructions" ]
                ]
            , ol [ class "instructions" ]
                [ firstStep
                , li []
                    [ text "To place a ship in your board select one by clicking on the gray boxes." ]
                , li []
                    [ text "The selected ship will turn green." ]
                , li []
                    [ text "Switch the orientation of the ship by clicking again on it." ]
                , li []
                    [ text "To place the selected ship click on the cell where you want it to start." ]
                , li []
                    [ text "Repeat the process until you place all your ships." ]
                , li []
                    [ text "Tha battle will start as soon as both players have placed all their ships." ]
                , li []
                    [ text "Good luck!" ]
                ]
            ]
