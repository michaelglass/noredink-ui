module Nri.Ui.Button.V9 exposing
    ( button, link
    , Attribute
    , icon, custom
    , onClick
    , href, linkSpa, linkExternal, linkWithMethod, linkWithTracking, linkExternalWithTracking
    , small, medium, large
    , exactWidth, unboundedWidth, fillContainerWidth
    , primary, secondary, danger, premium
    , enabled, unfulfilled, disabled, error, loading, success
    , delete
    , toggleButton
    )

{-|


# Changes from V8:

  - Changes API to be attribute-based, rather than config-based


# Create a button or link

@docs button, link
@docs Attribute
@docs icon, custom


## Behavior

@docs onClick
@docs href, linkSpa, linkExternal, linkWithMethod, linkWithTracking, linkExternalWithTracking


## Sizing

@docs small, medium, large
@docs exactWidth, unboundedWidth, fillContainerWidth


## Change the color scheme

@docs primary, secondary, danger, premium


## Change the state (buttons only)

@docs enabled, unfulfilled, disabled, error, loading, success


# Commonly-used buttons

@docs delete
@docs toggleButton

-}

import Accessibility.Styled as Html exposing (Attribute, Html)
import Accessibility.Styled.Role as Role
import Accessibility.Styled.Widget as Widget
import Css exposing (Style)
import Css.Global
import EventExtras.Styled as EventExtras
import Html as RootHtml
import Html.Styled as Styled
import Html.Styled.Attributes as Attributes
import Html.Styled.Events as Events
import Json.Decode
import Markdown.Block
import Markdown.Inline
import Nri.Ui
import Nri.Ui.AssetPath as AssetPath exposing (Asset)
import Colors.Extra as ColorsExtra
import Nri.Ui.Colors.V1 as Colors
import Nri.Ui.Fonts.V1
import Nri.Ui.Html.Attributes.V2 as AttributesExtra
import Nri.Ui.Svg.V1 as NriSvg exposing (Svg)
import Svg
import Svg.Attributes


styledName : String -> String
styledName suffix =
    "Nri-Ui-Button-V9-" ++ suffix


{-|

    Button.button "My great button!"
        [ Button.onClick ()
        , Button.enabled
        ]

By default, the button is enabled, Medium sized, with primary colors, and an unbounded width.

-}
button : String -> List (Attribute msg) -> Html msg
button name attributes =
    (label name :: attributes)
        |> List.foldl (\(Attribute attribute) b -> attribute b) build
        |> renderButton


{-|

    Button.link "My great link!"
        [ Button.href "My href"
        , Button.secondary
        ]

By default, the link is Medium sized, with primary colors, and an unbounded width.

-}
link : String -> List (Attribute msg) -> Html msg
link name attributes =
    (label name :: attributes)
        |> List.foldl (\(Attribute attribute) l -> attribute l) build
        |> renderLink


{-| -}
label : String -> Attribute msg
label label_ =
    set (\attributes -> { attributes | label = label_ })


{-| -}
icon : Svg -> Attribute msg
icon icon_ =
    set (\attributes -> { attributes | icon = Just icon_ })


{-| -}
custom : List (Html.Attribute msg) -> Attribute msg
custom attributes =
    set
        (\config ->
            { config
                | customAttributes = List.append config.customAttributes attributes
            }
        )



-- LINKING, CLICKING, and TRACKING BEHAVIOR


{-| -}
onClick : msg -> Attribute msg
onClick msg =
    set (\attributes -> { attributes | onClick = Just msg })


type Link
    = Default
    | WithTracking
    | SinglePageApp
    | WithMethod String
    | External
    | ExternalWithTracking


{-| -}
href : String -> Attribute msg
href url =
    set (\attributes -> { attributes | url = url })


{-| Use this link for routing within a single page app.

This will make a normal <a> tag, but change the Events.onClick behavior to avoid reloading the page.

See <https://github.com/elm-lang/html/issues/110> for details on this implementation.

-}
linkSpa : String -> Attribute msg
linkSpa url =
    set
        (\attributes ->
            { attributes
                | linkType = SinglePageApp
                , url = url
            }
        )


{-| Wrap some text so it looks like a button, but actually is wrapped in an anchor to
some url, and it's an HTTP request (Rails includes JS to make this use the given HTTP method)
-}
linkWithMethod : { method : String, url : String } -> Attribute msg
linkWithMethod { method, url } =
    set
        (\attributes ->
            { attributes
                | linkType = WithMethod method
                , url = url
            }
        )


{-| Wrap some text so it looks like a button, but actually is wrapped in an anchor to some url.
This should only take in messages that result in a Msg that triggers Analytics.trackAndRedirect.
For buttons that trigger other effects on the page, please use Nri.Button.button instead.
-}
linkWithTracking : { track : msg, url : String } -> Attribute msg
linkWithTracking { track, url } =
    set
        (\attributes ->
            { attributes
                | linkType = WithTracking
                , url = url
                , onClick = Just track
            }
        )


{-| Wrap some text so it looks like a button, but actually is wrapped in an anchor to
some url and have it open to an external site
-}
linkExternal : String -> Attribute msg
linkExternal url =
    set
        (\attributes ->
            { attributes
                | linkType = External
                , url = url
            }
        )


{-| Wrap some text so it looks like a button, but actually is wrapped in an anchor to some url and have it open to an external site.
-}
linkExternalWithTracking : { track : msg, url : String } -> Attribute msg
linkExternalWithTracking { track, url } =
    set
        (\attributes ->
            { attributes
                | linkType = ExternalWithTracking
                , url = url
                , onClick = Just track
            }
        )



-- BUTTON SIZING


{-| -}
small : Attribute msg
small =
    set (\attributes -> { attributes | size = Small })


{-| -}
medium : Attribute msg
medium =
    set (\attributes -> { attributes | size = Medium })


{-| -}
large : Attribute msg
large =
    set (\attributes -> { attributes | size = Large })



-- BUTTON WIDTH


type ButtonWidth
    = WidthExact Int
    | WidthUnbounded
    | WidthFillContainer


{-| Sizes for buttons and links that have button classes
-}
type ButtonSize
    = Small
    | Medium
    | Large


{-| Define a size in `px` for the button's total width.
-}
exactWidth : Int -> Attribute msg
exactWidth inPx =
    set (\attributes -> { attributes | width = WidthExact inPx })


{-| Leave the maxiumum width unbounded (there is a minimum width).
-}
unboundedWidth : Attribute msg
unboundedWidth =
    set (\attributes -> { attributes | width = WidthUnbounded })


{-| -}
fillContainerWidth : Attribute msg
fillContainerWidth =
    set (\attributes -> { attributes | width = WidthFillContainer })



-- COLOR SCHEMES


{-| -}
primary : Attribute msg
primary =
    set
        (\attributes ->
            { attributes | style = primaryColors }
        )


{-| -}
secondary : Attribute msg
secondary =
    set
        (\attributes ->
            { attributes | style = secondaryColors }
        )


{-| -}
danger : Attribute msg
danger =
    set
        (\attributes ->
            { attributes
                | style =
                    { background = Colors.red
                    , hover = Colors.redDark
                    , text = Colors.white
                    , border = Nothing
                    , shadow = Colors.redDark
                    }
            }
        )


{-| -}
premium : Attribute msg
premium =
    set
        (\attributes ->
            { attributes
                | style =
                    { background = Colors.yellow
                    , hover = Colors.ochre
                    , text = Colors.navy
                    , border = Nothing
                    , shadow = Colors.ochre
                    }
            }
        )



-- BUTTON STATE


type ButtonState
    = Enabled
    | Unfulfilled
    | Disabled
    | Error
    | Loading
    | Success


{-| -}
enabled : Attribute msg
enabled =
    set (\attributes -> { attributes | state = Enabled })


{-| Shows inactive styles.
-}
unfulfilled : Attribute msg
unfulfilled =
    set (\attributes -> { attributes | state = Unfulfilled })


{-| Shows inactive styling. If a button, this attribute will disable it.
-}
disabled : Attribute msg
disabled =
    set (\attributes -> { attributes | state = Disabled })


{-| Shows error styling. If a button, this attribute will disable it.
-}
error : Attribute msg
error =
    set (\attributes -> { attributes | state = Error })


{-| Shows loading styling. If a button, this attribute will disable it.
-}
loading : Attribute msg
loading =
    set (\attributes -> { attributes | state = Loading })


{-| Shows success styling. If a button, this attribute will disable it.
-}
success : Attribute msg
success =
    set (\attributes -> { attributes | state = Success })


{-| -}
type Attribute msg
    = Attribute (ButtonOrLink msg -> ButtonOrLink msg)



-- INTERNALS


set :
    (ButtonOrLinkAttributes msg -> ButtonOrLinkAttributes msg)
    -> Attribute msg
set with =
    Attribute (\(ButtonOrLink config) -> ButtonOrLink (with config))


build : ButtonOrLink msg
build =
    ButtonOrLink
        { onClick = Nothing
        , url = "#"
        , linkType = Default
        , size = Medium
        , style = primaryColors
        , width = WidthUnbounded
        , label = ""
        , state = Enabled
        , icon = Nothing
        , customAttributes = []
        }


type ButtonOrLink msg
    = ButtonOrLink (ButtonOrLinkAttributes msg)


type alias ButtonOrLinkAttributes msg =
    { onClick : Maybe msg
    , url : String
    , linkType : Link
    , size : ButtonSize
    , style : ColorPalette
    , width : ButtonWidth
    , label : String
    , state : ButtonState
    , icon : Maybe Svg
    , customAttributes : List (Html.Attribute msg)
    }


renderButton : ButtonOrLink msg -> Html msg
renderButton ((ButtonOrLink config) as button_) =
    let
        buttonStyle_ =
            getColorPalette button_

        isDisabled =
            case config.state of
                Enabled ->
                    False

                Disabled ->
                    True

                Error ->
                    True

                Unfulfilled ->
                    False

                Loading ->
                    True

                Success ->
                    True
    in
    Nri.Ui.styled Html.button
        (styledName "customButton")
        [ buttonStyles config.size config.width buttonStyle_ ]
        ((Maybe.map Events.onClick config.onClick
            |> Maybe.withDefault AttributesExtra.none
         )
            :: Attributes.disabled isDisabled
            :: Attributes.type_ "button"
            :: config.customAttributes
        )
        [ viewLabel config.icon config.label ]


renderLink : ButtonOrLink msg -> Html msg
renderLink ((ButtonOrLink config) as link_) =
    let
        colorPalette =
            getColorPalette link_

        linkBase linkFunctionName extraAttrs =
            Nri.Ui.styled Styled.a
                (styledName linkFunctionName)
                [ buttonStyles config.size config.width colorPalette ]
                (Attributes.href config.url :: extraAttrs)
                [ viewLabel config.icon config.label ]
    in
    case config.linkType of
        Default ->
            linkBase "link"
                (Attributes.target "_self" :: config.customAttributes)

        SinglePageApp ->
            linkBase "linkSpa"
                ((Maybe.map EventExtras.onClickPreventDefaultForLinkWithHref config.onClick
                    |> Maybe.withDefault AttributesExtra.none
                 )
                    :: config.customAttributes
                )

        WithMethod method ->
            linkBase "linkWithMethod"
                (Attributes.attribute "data-method" method
                    :: config.customAttributes
                )

        WithTracking ->
            linkBase
                "linkWithTracking"
                ((Maybe.map
                    (\msg ->
                        Events.preventDefaultOn "click"
                            (Json.Decode.succeed ( msg, True ))
                    )
                    config.onClick
                    |> Maybe.withDefault AttributesExtra.none
                 )
                    :: config.customAttributes
                )

        External ->
            linkBase "linkExternal"
                (Attributes.target "_blank" :: config.customAttributes)

        ExternalWithTracking ->
            linkBase "linkExternalWithTracking"
                (List.append
                    [ Attributes.target "_blank"
                    , Maybe.map EventExtras.onClickForLinkWithHref config.onClick
                        |> Maybe.withDefault AttributesExtra.none
                    ]
                    config.customAttributes
                )



-- DELETE BUTTON


{-| A delete button (blue X)
-}
delete : { label : String, onClick : msg } -> Html msg
delete config =
    Nri.Ui.styled Html.button
        (styledName "delete")
        [ Css.display Css.inlineBlock
        , Css.backgroundRepeat Css.noRepeat
        , Css.backgroundColor Css.transparent
        , Css.backgroundPosition Css.center
        , Css.backgroundSize Css.contain
        , Css.border Css.zero
        , Css.width (Css.px 15)
        , Css.height (Css.px 15)
        , Css.padding Css.zero
        , Css.margin2 Css.zero (Css.px 6)
        , Css.cursor Css.pointer
        , Css.color Colors.azure
        ]
        [ Events.onClick config.onClick
        , Attributes.type_ "button"
        , -- reference: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_button_role#Labeling_buttons
          Widget.label config.label
        ]
        [ Svg.svg [ Svg.Attributes.viewBox "0 0 25 25" ]
            [ Svg.title [] [ RootHtml.text "Delete" ]
            , Svg.path
                [ Svg.Attributes.fill "#146aff" -- TODO: this should be azure, but css colors aren't extractable afaik
                , Svg.Attributes.d "M1.067 6.015c-1.423-1.422-1.423-3.526 0-4.948 1.422-1.423 3.526-1.423 4.948 0l6.371 6.37 6.371-6.37c1.422-1.423 3.783-1.423 5.176 0 1.423 1.422 1.423 3.782 0 5.176l-6.37 6.37 6.37 6.372c1.423 1.422 1.423 3.526 0 4.948-1.422 1.423-3.526 1.423-4.948 0l-6.371-6.37-6.371 6.37c-1.422 1.423-3.783 1.423-5.176 0-1.423-1.422-1.423-3.782 0-5.176l6.37-6.143-6.37-6.599z"
                ]
                []
            ]
            |> Styled.fromUnstyled
        ]



-- TOGGLE BUTTON


{-| A button that can be toggled into a pressed state and back again.
-}
toggleButton :
    { label : String
    , onSelect : msg
    , onDeselect : msg
    , pressed : Bool
    }
    -> Html msg
toggleButton config =
    let
        toggledStyles =
            if config.pressed then
                Css.batch
                    [ Css.color Colors.gray20
                    , Css.backgroundColor Colors.glacier
                    , Css.boxShadow5 Css.inset Css.zero (Css.px 3) Css.zero (ColorsExtra.withAlpha 0.2 Colors.gray20)
                    , Css.border3 (Css.px 1) Css.solid Colors.azure
                    , Css.fontWeight Css.bold
                    ]

            else
                Css.batch
                    []
    in
    Nri.Ui.styled Html.button
        (styledName "toggleButton")
        [ buttonStyles Medium WidthUnbounded secondaryColors
        , toggledStyles
        ]
        [ Events.onClick
            (if config.pressed then
                config.onDeselect

             else
                config.onSelect
            )
        , Widget.pressed <| Just config.pressed

        -- reference: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_button_role#Labeling_buttons
        , Role.button

        -- Note: setting type: 'button' removes the default behavior of submit
        -- equivalent to preventDefaultBehavior = false
        -- https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button#attr-name
        , Attributes.type_ "button"
        ]
        [ viewLabel Nothing config.label ]


buttonStyles : ButtonSize -> ButtonWidth -> ColorPalette -> Style
buttonStyles size width colors =
    Css.batch
        [ buttonStyle
        , sizeStyle size width
        , colorStyle colors
        ]


viewLabel : Maybe Svg -> String -> Html msg
viewLabel maybeSvg label_ =
    Nri.Ui.styled Html.span
        "button-label-span"
        [ Css.overflow Css.hidden -- Keep scrollbars out of our button
        , Css.overflowWrap Css.breakWord -- Ensure that words that exceed the button width break instead of disappearing
        , Css.padding2 (Css.px 2) Css.zero -- Without a bit of bottom padding, text that extends below the baseline, like "g" gets cut off
        ]
        []
        (case maybeSvg of
            Nothing ->
                renderMarkdown label_

            Just svg ->
                NriSvg.toHtml svg :: renderMarkdown label_
        )


renderMarkdown : String -> List (Html msg)
renderMarkdown markdown =
    case Markdown.Block.parse Nothing markdown of
        -- It seems to be always first wrapped in a `Paragraph` and never directly a `PlainInline`
        [ Markdown.Block.Paragraph _ inlines ] ->
            List.map (Markdown.Inline.toHtml >> Styled.fromUnstyled) inlines

        _ ->
            [ Html.text markdown ]



-- STYLES


buttonStyle : Style
buttonStyle =
    Css.batch
        [ Css.cursor Css.pointer
        , -- Specifying the font can and should go away after bootstrap is removed from application.css
          Nri.Ui.Fonts.V1.baseFont
        , Css.textOverflow Css.ellipsis
        , Css.overflow Css.hidden
        , Css.textDecoration Css.none
        , Css.backgroundImage Css.none
        , Css.textShadow Css.none
        , Css.property "transition" "background-color 0.2s, color 0.2s, box-shadow 0.2s, border 0.2s, border-width 0s"
        , Css.boxShadow Css.none
        , Css.border Css.zero
        , Css.marginBottom Css.zero
        , Css.hover [ Css.textDecoration Css.none ]
        , Css.disabled [ Css.cursor Css.notAllowed ]
        , Css.display Css.inlineFlex
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        ]



-- COLORS


type alias ColorPalette =
    { background : Css.Color
    , hover : Css.Color
    , text : Css.Color
    , border : Maybe Css.Color
    , shadow : Css.Color
    }


primaryColors : ColorPalette
primaryColors =
    { background = Colors.azure
    , hover = Colors.azureDark
    , text = Colors.white
    , border = Nothing
    , shadow = Colors.azureDark
    }


secondaryColors : ColorPalette
secondaryColors =
    { background = Colors.white
    , hover = Colors.glacier
    , text = Colors.azure
    , border = Just <| Colors.azure
    , shadow = Colors.azure
    }


getColorPalette : ButtonOrLink msg -> ColorPalette
getColorPalette (ButtonOrLink config) =
    case config.state of
        Enabled ->
            config.style

        Disabled ->
            { background = Colors.gray92
            , hover = Colors.gray92
            , text = Colors.gray45
            , border = Nothing
            , shadow = Colors.gray92
            }

        Error ->
            { background = Colors.purple
            , hover = Colors.purple
            , text = Colors.white
            , border = Nothing
            , shadow = Colors.purple
            }

        Unfulfilled ->
            { background = Colors.gray92
            , hover = Colors.gray92
            , text = Colors.gray45
            , border = Nothing
            , shadow = Colors.gray92
            }

        Loading ->
            { background = Colors.glacier
            , hover = Colors.glacier
            , text = Colors.navy
            , border = Nothing
            , shadow = Colors.glacier
            }

        Success ->
            { background = Colors.greenDark
            , hover = Colors.greenDark
            , text = Colors.white
            , border = Nothing
            , shadow = Colors.greenDark
            }


colorStyle : ColorPalette -> Style
colorStyle colorPalette =
    Css.batch
        [ Css.color colorPalette.text
        , Css.backgroundColor colorPalette.background
        , Css.fontWeight (Css.int 700)
        , Css.textAlign Css.center
        , case colorPalette.border of
            Nothing ->
                Css.borderStyle Css.none

            Just color ->
                Css.batch
                    [ Css.borderColor color
                    , Css.borderStyle Css.solid
                    ]
        , Css.borderBottomStyle Css.solid
        , Css.borderBottomColor colorPalette.shadow
        , Css.fontStyle Css.normal
        , Css.hover
            [ Css.color colorPalette.text
            , Css.backgroundColor colorPalette.hover
            , Css.disabled [ Css.backgroundColor colorPalette.background ]
            ]
        , Css.visited [ Css.color colorPalette.text ]
        ]


sizeStyle : ButtonSize -> ButtonWidth -> Style
sizeStyle size width =
    let
        config =
            case size of
                Small ->
                    { fontSize = 15
                    , height = 36
                    , imageHeight = 15
                    , shadowHeight = 2
                    , minWidth = 75
                    }

                Medium ->
                    { fontSize = 17
                    , height = 45
                    , imageHeight = 15
                    , shadowHeight = 3
                    , minWidth = 100
                    }

                Large ->
                    { fontSize = 20
                    , height = 56
                    , imageHeight = 20
                    , shadowHeight = 4
                    , minWidth = 200
                    }

        sizingAttributes =
            let
                verticalPaddingPx =
                    2
            in
            [ Css.minHeight (Css.px config.height)
            , Css.paddingTop (Css.px verticalPaddingPx)
            , Css.paddingBottom (Css.px verticalPaddingPx)
            ]

        widthAttributes =
            case width of
                WidthExact pxWidth ->
                    [ Css.maxWidth (Css.pct 100)
                    , Css.width (Css.px <| toFloat pxWidth)
                    , Css.paddingRight (Css.px 4)
                    , Css.paddingLeft (Css.px 4)
                    ]

                WidthUnbounded ->
                    [ Css.paddingLeft (Css.px 16)
                    , Css.paddingRight (Css.px 16)
                    , Css.minWidth (Css.px config.minWidth)
                    ]

                WidthFillContainer ->
                    [ Css.paddingLeft (Css.px 16)
                    , Css.paddingRight (Css.px 16)
                    , Css.minWidth (Css.px config.minWidth)
                    , Css.width (Css.pct 100)
                    ]

        lineHeightPx =
            case size of
                Small ->
                    15

                Medium ->
                    19

                Large ->
                    22
    in
    Css.batch
        [ Css.fontSize (Css.px config.fontSize)
        , Css.borderRadius (Css.px 8)
        , Css.lineHeight (Css.px lineHeightPx)
        , Css.boxSizing Css.borderBox
        , Css.borderWidth (Css.px 1)
        , Css.borderBottomWidth (Css.px config.shadowHeight)
        , Css.batch sizingAttributes
        , Css.batch widthAttributes
        , Css.Global.descendants
            [ Css.Global.img
                [ Css.height (Css.px config.imageHeight)
                , Css.marginRight (Css.px <| config.imageHeight / 6)
                , Css.position Css.relative
                , Css.bottom (Css.px 2)
                , Css.verticalAlign Css.middle
                ]
            , Css.Global.svg
                [ Css.height (Css.px config.imageHeight) |> Css.important
                , Css.width (Css.px config.imageHeight) |> Css.important
                , Css.marginRight (Css.px <| config.imageHeight / 6)
                , Css.position Css.relative
                , Css.bottom (Css.px 2)
                , Css.verticalAlign Css.middle
                ]
            , Css.Global.svg
                [ Css.important <| Css.height (Css.px config.imageHeight)
                , Css.important <| Css.width Css.auto
                , Css.maxWidth (Css.px (config.imageHeight * 1.25))
                , Css.paddingRight (Css.px <| config.imageHeight / 6)
                , Css.position Css.relative
                , Css.bottom (Css.px 2)
                , Css.verticalAlign Css.middle
                ]
            ]
        ]
