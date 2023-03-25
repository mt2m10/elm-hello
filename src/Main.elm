module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, li, text, ul)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    -- modelのプロパティ
    { newTodo : String
    , todos : List String
    , errorMessage : String
    }


init : Model
init =
    -- modelの初期状態
    Model "" [] ""


type Msg
    = EnteredText String
    | AddTodo
    | ClearErrorMessage



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    -- イベント操作
    -- type Msg と関連している
    case msg of
        EnteredText text ->
            { model | newTodo = text }

        AddTodo ->
            let
                newTodo =
                    String.trim model.newTodo
            in
            if String.isEmpty newTodo then
                { model | errorMessage = "TODOを入力してください。" }

            else
                { model | newTodo = "", todos = newTodo :: model.todos, errorMessage = "" }

        ClearErrorMessage ->
            { model | errorMessage = "" }



--- VIEW


view : Model -> Html Msg
view model =
    -- 親view
    div [ class "container" ]
        [ viewTitle
        , viewInput model
        , viewOutput model
        ]


viewTitle : Html Msg
viewTitle =
    -- タイトル
    div [ class "fs-2 mb-3" ] [ text "Todos" ]


viewInput : Model -> Html Msg
viewInput model =
    -- 入力部
    div [ class "row mb-3" ]
        [ div [ class "col-sm-5" ]
            [ input
                [ class "form-control"
                , onInput EnteredText
                , placeholder "input todo"
                , value model.newTodo
                , if String.isEmpty model.errorMessage then
                    class ""

                  else
                    class "is-invalid"
                ]
                []
            ]
        , div [ class "col-sm-5" ] [ button [ class "btn btn-primary", onClick AddTodo ] [ text "Add" ] ]
        , if String.isEmpty model.errorMessage then
            text ""

          else
            div [ class "text-danger mt-1" ]
                [ text model.errorMessage ]
        ]


viewOutput : Model -> Html Msg
viewOutput model =
    -- 出力部
    div [] [ todoList model.todos ]


todoList : List String -> Html Msg
todoList todos =
    ul [] (List.map todoListItem todos)


todoListItem : String -> Html Msg
todoListItem todo =
    li [] [ text todo ]
