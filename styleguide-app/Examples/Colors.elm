module Examples.Colors exposing (example)

{-|

@docs example

-}

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attributes exposing (css)
import ModuleExample as ModuleExample exposing (Category(..), ModuleExample)
import Nri.Ui.Colors.V1 as Colors


example : ModuleExample msg
example =
    { filename = "Nri/Colors.elm"
    , category = Colors
    , content =
        [ [ ( "gray20", Colors.gray20, "Main text" )
          , ( "gray45", Colors.gray45, "Secondary text, 0-69 score" )
          , ( "gray75", Colors.gray75, "Border of form elements and tabs" )
          , ( "gray92", Colors.gray92, "Dvdrs/rules, incomplete assmt, inactive tabs/dsbld buttons" )
          , ( "gray96", Colors.gray96, "backgrounds/alternating rows" )
          , ( "navy", Colors.navy, "Headings, indented compts, labels, tooltip bckgrnds" )
          , ( "azure", Colors.azure, "Buttons, other clickable stuff, links" )
          , ( "azureDark", Colors.azureDark, "Azure button shadow" )
          , ( "frost", Colors.frost, "Blue backgrounds pairing with Navy and Azure" )
          , ( "glacier", Colors.glacier, "Blue highlights/selected elements" )
          , ( "lichen", Colors.lichen, "70-79 score" )
          , ( "grassland", Colors.grassland, "80-89 score" )
          , ( "green", Colors.green, "90-100 score" )
          , ( "greenDark", Colors.greenDark, "Green button, swathes of green" )
          , ( "greenDarkest", Colors.greenDarkest, "Green text, green button shadow" )
          , ( "greenLight", Colors.greenLight, "Green backgrounds" )
          , ( "greenLightest", Colors.greenLightest, "Green backgrounds" )
          , ( "cornflower", Colors.cornflower, "Mastery level 1" )
          , ( "cornflowerDark", Colors.cornflowerDark, "Mastery level 1 text" )
          , ( "cornflowerLight", Colors.cornflowerLight, "Background to pair with Cornflower elements" )
          , ( "aqua", Colors.aqua, "Master level 2" )
          , ( "aquaDark", Colors.aquaDark, "Text to pair with Aqua elements" )
          , ( "aquaLight", Colors.aquaLight, "Background to pair with Aqua elements" )
          , ( "turquoise", Colors.turquoise, "Master level 3, writing cycles" )
          , ( "turquoiseDark", Colors.turquoiseDark, "Text to pair with turquoise elements" )
          , ( "turquoiseLight", Colors.turquoiseLight, "Background to pair with turquoise elements" )
          , ( "purple", Colors.purple, "Wrong, form errors, diagnostics, purple button" )
          , ( "purpleDark", Colors.purpleDark, "Purple text, purple button shadow" )
          , ( "purpleLight", Colors.purpleLight, "Purple backgrounds" )
          , ( "red", Colors.red, "NoRedInk red, form warnings, practice" )
          , ( "redDark", Colors.redDark, "Red links/text, red button shadow" )
          , ( "redLight", Colors.redLight, "Red backgrounds" )
          , ( "cyan", Colors.cyan, "Blue Highlighter" )
          , ( "magenta", Colors.magenta, "Pink highlighter" )
          , ( "yellow", Colors.yellow, "Yellow highlighter" )
          , ( "ochre", Colors.ochre, "Yellow button shadow" )
          , ( "sunshine", Colors.sunshine, "Yellow highlights, tips" )
          ]
            |> List.map viewColor
            |> Html.div
                [ css
                    [ Css.maxWidth (Css.px 12000)
                    , Css.displayFlex
                    , Css.flexWrap Css.wrap
                    ]
                ]
            |> Html.toUnstyled
        ]
    }


viewColor : ( String, Css.Color, String ) -> Html.Html msg
viewColor ( name, color, description ) =
    Html.div
        [ css
            [ Css.width (Css.px 250)
            , Css.displayFlex
            , Css.display Css.inlineBlock -- TODO why flex & block?
            , Css.height (Css.px 160)
            , Css.textAlign Css.center
            , Css.backgroundColor color
            , Css.color Colors.gray20 -- TODO  font specific
            , Css.margin (Css.px 4)
            , Css.textShadow4 Css.zero Css.zero (Css.px 6) Colors.white -- TODO Font specific
            , Css.borderRadius (Css.px 4)
            , Css.padding (Css.px 8)
            , Css.fontSize (Css.px 20) -- TODO move fontsizes to avoid weird inheritance
            ]
        ]
        [ Html.text name
        , Html.div [ css [ Css.fontSize (Css.px 10) ] ] [ Html.text description ]
        , Html.br [] []
        , Html.text color.value
        ]
