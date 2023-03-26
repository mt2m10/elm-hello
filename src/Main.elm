module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as Json
import List.Extra exposing (getAt, setAt)


main =
    Browser.sandbox { init = init, update = update, view = view }


onKeyDownWithCtrl : (Int -> Bool -> msg) -> Html.Attribute msg
onKeyDownWithCtrl msg =
    let
        ctrlKey =
            Json.field "ctrlKey" Json.bool

        decoder =
            Json.map2 msg keyCode ctrlKey
    in
    on "keydown" decoder



-- MODEL


type alias Model =
    -- modelのプロパティ
    { newTodo : String
    , todos : List TodoModel
    , completedTodos : List String
    , errorMessage : String
    }


type alias TodoModel =
    { value : String
    , isComplete : Bool
    , delete : Bool
    }


init : Model
init =
    -- modelの初期状態
    Model "" [] [] ""


type Msg
    = EnteredText String
    | AddTodo
    | ClearErrorMessage
    | CompleteTodo Int Bool
    | DeleteTodo Int
    | OnKeyDownWithCtrl Int Bool



-- UPDATE


addTodo : Model -> Model
addTodo model =
    -- todo追加関数
    let
        newTodo =
            { value = String.trim model.newTodo, isComplete = False, delete = False }
    in
    if String.isEmpty newTodo.value then
        { model | errorMessage = "TODOを入力してください。" }

    else
        { model | newTodo = "", todos = List.append model.todos [ newTodo ], errorMessage = "" }


update : Msg -> Model -> Model
update msg model =
    -- イベント操作
    -- type Msg と関連している
    case msg of
        EnteredText text ->
            -- todo入力
            { model | newTodo = text }

        AddTodo ->
            -- todo追加
            addTodo model

        ClearErrorMessage ->
            -- エラーメッセージ消去
            { model | errorMessage = "" }

        CompleteTodo index isComplete ->
            -- todo完了
            let
                todo =
                    getAt index model.todos |> Maybe.withDefault { value = "", isComplete = False, delete = False }

                updatedTodo =
                    { todo | isComplete = isComplete }

                updatedTodos =
                    setAt index updatedTodo model.todos
            in
            { model | todos = updatedTodos }

        DeleteTodo index ->
            -- todo削除
            let
                todo =
                    getAt index model.todos |> Maybe.withDefault { value = "", isComplete = False, delete = False }

                updatedTodo =
                    { todo | delete = True }

                updatedTodos =
                    setAt index updatedTodo model.todos
            in
            { model | todos = updatedTodos }

        OnKeyDownWithCtrl code ctrlKey ->
            case ( code, ctrlKey ) of
                ( 13, True ) ->
                    -- enter + ctrl
                    addTodo model

                ( _, _ ) ->
                    model



--- VIEW


view : Model -> Html Msg
view model =
    -- 親view
    div [ class "container" ]
        [ viewHeader
        , viewInput model
        , viewOutput model
        , viewFooter
        ]


viewHeader : Html Msg
viewHeader =
    header [ class "mb-3 d-flex justify-content-between align-items-end col-sm-8" ]
        [ div [ class "fs-2" ] [ text "Todos" ]
        , div []
            [ button [ class "btn btn-link", attribute "data-bs-toggle" "modal", attribute "data-bs-target" "#explainModal" ] [ text "使い方" ]
            , viewHowToUseModal
            , button
                [ class "btn btn-link", attribute "data-bs-toggle" "modal", attribute "data-bs-target" "#impressionsModal" ]
                [ text "感想" ]
            , viewImpressionsModal
            ]
        ]


viewInput : Model -> Html Msg
viewInput model =
    -- 入力部
    div [ class "row mb-5" ]
        [ div [ class "col-sm-5 d-flex" ]
            [ input
                [ class "form-control me-2"
                , onInput EnteredText
                , placeholder "input todo"
                , value model.newTodo
                , if String.isEmpty model.errorMessage then
                    class ""

                  else
                    class "is-invalid"
                , onKeyDownWithCtrl OnKeyDownWithCtrl
                ]
                []
            , button [ class "btn btn-primary", onClick AddTodo ] [ text "Add" ]
            ]
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


todoList : List TodoModel -> Html Msg
todoList todos =
    ul [ class "ps-0" ] (List.indexedMap todoListItem todos)


todoListItem : Int -> TodoModel -> Html Msg
todoListItem index todo =
    li
        [ class "col-sm-8 d-flex justify-content-between align-items-center px-4 py-2 border rounded-1 mb-2"
        , if todo.isComplete == True then
            class "bg-success bg-opacity-10"

          else
            class ""
        , if todo.delete == True then
            -- ダサいけど、見えないようにだけする
            class "d-none"

          else
            class ""
        ]
        [ div []
            [ div []
                [ input
                    [ type_ "checkbox"
                    , id ("checkComplete" ++ String.fromInt index)
                    , class "me-2"
                    , checked todo.isComplete
                    , onClick (CompleteTodo index (not todo.isComplete))
                    ]
                    []
                , label [ for ("checkComplete" ++ String.fromInt index) ] [ text todo.value ]
                ]
            ]
        , div []
            [ button [ class "btn btn-outline-danger btn-sm", onClick (DeleteTodo index) ] [ text "del" ]
            ]
        ]


viewFooter : Html Msg
viewFooter =
    -- フッター
    footer [ class "position-absolute bottom-0 start-50 translate-middle-x" ] [ p [] [ text "© 2023 Masashi Tanimoto. All rights reserved." ] ]


viewHowToUseModal : Html Msg
viewHowToUseModal =
    div [ id "explainModal", class "modal", tabindex -1 ]
        [ div [ class "modal-dialog modal-lg" ]
            [ div [ class "modal-content" ]
                [ div [ class "modal-header" ]
                    [ h5 [ class "modal-title" ] [ text "使い方" ]
                    ]
                , div [ class "modal-body" ]
                    [ ul []
                        [ li [] [ text "テキストボックスにTODOを入力して、「Add」ボタンをクリックすると追加されます。" ]
                        , li [] [ text "「Add」ボタンの代わりに [Ctrl + Enter] でも追加可能です。" ]
                        , li [] [ text "チェックボックスをONにすると完了ステータスとみなします。" ]
                        , li [] [ text "「del」ボタンでTodoを削除します。" ]
                        , li [] [ text "TODOは保存されません。リロードすると入力したTODOはすべて消えます。" ]
                        ]
                    ]
                ]
            ]
        ]


viewImpressionsModal : Html Msg
viewImpressionsModal =
    div [ id "impressionsModal", class "modal", tabindex -1 ]
        [ div [ class "modal-dialog modal-lg" ]
            [ div [ class "modal-content" ]
                [ div [ class "modal-header" ]
                    [ h5 [ class "modal-title" ] [ text "感想" ]
                    ]
                , div [ class "modal-body" ]
                    [ div []
                        [ text "Elmは、他の言語に比べて学びが難しい部分があり、ChatGPTに結構頼りましたが、関数型プログラミングの考え方やアプローチを学ぶことができました。ただ、次に学ぶならばScala、Haskell、Elixirのような関数型プログラミング言語を選ぶ方が良いかもしれません。"
                        , br [] []
                        , br [] []
                        , text "また、最新のElmのバージョンが2019年であることを知り、あまり活発ではないと感じました。そのため、実務で採用することは難しいかもしれません。"
                        , br [] []
                        , br [] []
                        , text "ただ、Elmでの書き方を学ぶことで関数型プログラミングについての理解を深めることができました。Elmは他の関数型プログラミング言語とは異なる特徴を持っていますが、そのアプローチを学ぶことでプログラムの書き方に新しい視点を与えてくれました。言語の選択は失敗とは言えないかもしれません。"
                        ]
                    ]
                ]
            ]
        ]
