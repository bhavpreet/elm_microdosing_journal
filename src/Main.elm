module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, img)
import Html.Attributes exposing (src, style)
-- import Element exposing (Element, html, el, image, row, column, alignRight, fill, height, width, rgb255, spacing, centerY, centerX, padding)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Element.Input as Input
import Material.Button as Button
import Material.IconButton as IconButton
import Chart



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = Clicked
    | ClickMsg


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
                   ] <|
        column [ padding 25
               , centerX
               , width (fill |> maximum 500)
               ]
        [ el [ padding 27 ] none
        , paragraph [ ]
            [ el [ centerX
                 , Font.size 25
                 , Font.bold
                 , Font.family
                       [ Font.typeface "Open Sans"
                       , Font.sansSerif
                       ]
                 , Region.heading 1
                 ] (text "Microdosing Journal")
            ]
        , el [ padding 32 ] none
        , el [ width fill
             -- , Background.color <| rgb255 211 211 211 -- silver Grey
             , Background.color <| white
             , Border.rounded 15 ] <| html <| Chart.chart

        , el [ padding 22 ] none
        , row [ centerX ]
            [ el [ Border.width 2
                 , Border.rounded 50 ] <| html <|
                  IconButton.iconButton
                  (IconButton.config
                  |> IconButton.setOnClick Clicked)
                  (IconButton.icon "note_add")
            , el [ padding 7 ] none
            , el [ Border.width 2
                 , Border.rounded 50] <| html <|
                IconButton.iconButton
                    (IconButton.config |> IconButton.setOnClick Clicked)
                    (IconButton.icon "colorize")
            ]

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


--

white = rgb255 255 255 255
