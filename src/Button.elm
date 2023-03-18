module Button exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, br, button, div, hr, text)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    Int


init : Model
init =
    0



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Reset
    | AddTen


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        Reset ->
            0

        AddTen ->
            model + 10



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        , br [] []
        , button [ onClick AddTen ] [ text "+10" ]
        , hr [] []
        , button [ onClick Reset ] [ text "reset" ]
        ]
