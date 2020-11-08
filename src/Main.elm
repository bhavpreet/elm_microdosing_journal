module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img)
import Html.Attributes exposing (src)
-- import Element exposing (Element, html, el, image, row, column, alignRight, fill, height, width, rgb255, spacing, centerY, centerX, padding)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Material.Button as Button



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = Clicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.layout [ Background.gradient { angle=pi
                                         , steps=[ rgb255 255 171 64
                                                 , rgb255 149 117 205
                                                 ]
                                         }
                   -- , Background.color <| rgb 0 0 0
                   ] <|
        column [ centerX
               ]
            [ image [ centerX, width <| px 110 ] { src = "/logo.svg"
                       , description = "my logo" }
            , el [ padding 10 ] none
            , el [ Font.heavy ] (text "Your Elm App is working!")
            , el [ padding 10 ] none
            , el [ centerX ] <|
                html <| Button.raised (Button.config |> Button.setOnClick Clicked) "+1"
            ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
