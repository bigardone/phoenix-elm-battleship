module Game.Result.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Game.Model exposing (..)
import Msg exposing (..)
import Logo.View as Logo


view : String -> Model -> Html Msg
view playerId model =
    let
        message =
            if playerId == Maybe.withDefault "" model.winnerId then
                "Yo Ho Ho, victory is yours!"
            else
                "You got wrecked, landlubber!"

        twitterMessage =
            if playerId == Maybe.withDefault "" model.winnerId then
                "Yo Ho Ho, I won a battle at Phoenix Battleship"
            else
                "I got wrecked at Phoenix Battleship"
    in
        div [ id "game_result" ]
            [ header
                []
                [ Logo.view
                , h1
                    []
                    [ text "Game over" ]
                , p
                    []
                    [ text message ]
                , a
                    [ class "twitter-hashtag-button"
                    , href ("https://twitter.com/intent/tweet?url=https://phoenix-elm-battleship.herokuapp.com&button_hashtag=myelixirstatus&text=" ++ twitterMessage)
                    ]
                    [ i
                        [ class "fa fa-twitter" ]
                        []
                    , text " Share result"
                    ]
                ]
            , a
                [ onClick NavigateToHome ]
                [ text "Back to home" ]
            ]
