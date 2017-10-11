module Main exposing (Model, Msg, update, view, subscriptions, init)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (src)
import Json.Decode
import Http
import Json.Decode.Pipeline exposing (decode, required)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { icon_url : String
    , id : String
    , url : String
    , value : String
    }


type Msg
    = FetchJoke
    | ReceiveJoke (Result Http.Error Model)


initialModel : Model
initialModel =
    { icon_url = ""
    , id = ""
    , url = ""
    , value = ""
    }


apiEndpoint : String
apiEndpoint =
    "https://api.chucknorris.io/jokes/random"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchJoke ->
            ( model, fetchJoke )

        ReceiveJoke (Ok joke) ->
            ( joke, Cmd.none )

        ReceiveJoke (Err _) ->
            ( model, Cmd.none )


fetchJoke : Cmd Msg
fetchJoke =
    Http.send ReceiveJoke (Http.get apiEndpoint jokeDecoder)


jokeDecoder : Json.Decode.Decoder Model
jokeDecoder =
    decode Model
        |> required "icon_url" Json.Decode.string
        |> required "id" Json.Decode.string
        |> required "url" Json.Decode.string
        |> required "value" Json.Decode.string


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Chuck Norris Jokes" ]
        , viewJoke model
        , button [ onClick FetchJoke ] [ text "Fetch a new Joke" ]
        ]


viewJoke : Model -> Html msg
viewJoke model =
    div []
        [ img [ src model.icon_url ] []
        , p [] [ text model.value ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )
