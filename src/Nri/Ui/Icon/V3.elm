module Nri.Ui.Icon.V3 exposing
    ( icon, decorativeIcon, link, linkExternal, linkSpa, button
    , IconType, IconSize(..), IconLinkSpaModel
    , activity
    , add
    , arrowDown
    , arrowLeft
    , arrowRight
    , assignmentStartButtonPrimary
    , assignmentStartButtonSecondary
    , assignmentTypeDiagnostic
    , assignmentTypePeerReview
    , assignmentTypeSelfReview
    , assignmentTypePractice
    , assignmentTypeQuickWrite
    , assignmentTypeQuiz
    , assignmentTypeWritingCycle
    , attention
    , bang
    , bulb
    , calendar
    , caret
    , checkMark
    , checkMarkSquiggily
    , checkMarkSvg
    , class
    , clever
    , clock
    , close
    , compassSvg
    , copy
    , custom
    , darkBlueCheckMark
    , document
    , download
    , edit
    , editWriting
    , equalitySign
    , exclamation
    , facebook
    , flag
    , flipper
    , footsteps
    , gardening
    , gear
    , greenCheckMark
    , guidedWrite
    , hat
    , help
    , helpSvg
    , highFive
    , key
    , keychain
    , late
    , leaderboard
    , lightBulb
    , lock
    , lockDeprecated
    , logo
    , masteryBadge
    , newspaper
    , notStarred
    , okay
    , openClose
    , peerReview
    , pen
    , performance
    , personBlue
    , preview
    , quickWrite
    , seeMore
    , share
    , skip
    , sort
    , sortArrow
    , speedometer
    , starred
    , submitting, rating, revising
    , thumbsUp
    , twitter
    , unarchive
    , writingAssignment
    , x
    , xSvg
    )

{-|

@docs icon, decorativeIcon, link, linkExternal, linkSpa, button
@docs IconType, IconSize, IconLinkSpaModel
@docs activity
@docs add
@docs arrowDown
@docs arrowLeft
@docs arrowRight
@docs assignmentStartButtonPrimary
@docs assignmentStartButtonSecondary
@docs assignmentTypeDiagnostic
@docs assignmentTypePeerReview
@docs assignmentTypeSelfReview
@docs assignmentTypePractice
@docs assignmentTypeQuickWrite
@docs assignmentTypeQuiz
@docs assignmentTypeWritingCycle
@docs attention
@docs bang
@docs bulb
@docs calendar
@docs caret
@docs checkMark
@docs checkMarkSquiggily
@docs checkMarkSvg
@docs class
@docs clever
@docs clock
@docs close
@docs compassSvg
@docs copy
@docs custom
@docs darkBlueCheckMark
@docs document
@docs download
@docs edit
@docs editWriting
@docs equalitySign
@docs exclamation
@docs facebook
@docs flag
@docs flipper
@docs footsteps
@docs gardening
@docs gear
@docs greenCheckMark
@docs guidedWrite
@docs hat
@docs help
@docs helpSvg
@docs highFive
@docs key
@docs keychain
@docs late
@docs leaderboard
@docs lightBulb
@docs lock
@docs lockDeprecated
@docs logo
@docs masteryBadge
@docs newspaper
@docs notStarred
@docs okay
@docs openClose
@docs peerReview
@docs pen
@docs performance
@docs personBlue
@docs preview
@docs quickWrite
@docs seeMore
@docs share
@docs skip
@docs sort
@docs sortArrow
@docs speedometer
@docs starred
@docs submitting, rating, revising
@docs thumbsUp
@docs twitter
@docs unarchive
@docs writingAssignment
@docs x
@docs xSvg

-}

import Accessibility.Role as Role
import Accessibility.Styled exposing (..)
import Css exposing (..)
import EventExtras
import Html as RootHtml
import Html.Attributes as RootAttr exposing (..)
import Html.Styled
import Html.Styled.Attributes as Attributes exposing (css)
import Html.Styled.Events as Events
import Nri.Ui.AssetPath exposing (Asset(..))
import Nri.Ui.Colors.V1
import Svg exposing (svg, use)
import Svg.Attributes exposing (xlinkHref)


{-| -}
type alias IconLinkModel =
    { alt : String
    , url : String
    , icon : IconType
    , disabled : Bool
    , size : IconSize
    }


{-| -}
type alias IconLinkSpaModel route =
    { alt : String
    , icon : IconType
    , disabled : Bool
    , size : IconSize
    , route : route
    }


type alias IconButtonModel msg =
    { alt : String
    , msg : msg
    , icon : IconType
    , disabled : Bool
    , size : IconSize
    }


{-| An icon that can be rendered using the functions provided by this module.
-}
type IconType
    = ImgIcon Asset
    | SvgIcon String


{-| Used for determining sizes on Icon.buttons and Icon.links
-}
type IconSize
    = Small
    | Medium


{-| Create an icon that links to a part of NRI
Uses our default icon styles (25 x 25 px, azure)
-}
link : IconLinkModel -> Html msg
link =
    linkBase [ Attributes.target "_self" ]


{-| Create an accessible icon button with an onClick handler
Uses our default icon styles (25 x 25 px, azure)
-}
button : IconButtonModel msg -> Html msg
button model =
    Accessibility.Styled.button
        [ css
            [ Css.batch
                [ backgroundColor transparent
                , border zero
                , color Nri.Ui.Colors.V1.azure
                , fontFamily inherit
                , Css.property "cursor" "pointer"
                , padding zero
                , focus
                    [ backgroundColor transparent
                    ]
                ]
            , sizeStyles model.size
            ]
        , Events.onClick model.msg
        , Attributes.disabled model.disabled
        , Attributes.type_ "button"
        ]
        [ icon
            { alt = model.alt
            , icon = model.icon
            }
        ]


{-| -}
icon : { alt : String, icon : IconType } -> Html msg
icon config =
    case config.icon of
        SvgIcon iconId ->
            svg svgStyle
                [ Svg.title [] [ RootHtml.text config.alt ]
                , use [ xlinkHref ("#" ++ iconId) ] []
                ]
                |> Html.Styled.fromUnstyled

        ImgIcon assetPath ->
            img config.alt
                [ Attributes.src (Nri.Ui.AssetPath.url assetPath)
                ]


{-| Use this icon for purely decorative content that would be distracting
rather than helpful on a screenreader.
-}
decorativeIcon : IconType -> Html msg
decorativeIcon iconType =
    case iconType of
        SvgIcon iconId ->
            svg
                (Role.img :: svgStyle)
                [ use [ xlinkHref ("#" ++ iconId) ] []
                ]
                |> Html.Styled.fromUnstyled

        ImgIcon assetPath ->
            decorativeImg [ Attributes.src (Nri.Ui.AssetPath.url assetPath) ]


{-| Use this link for routing within a single page app.

This will make a normal <a> tag, but change the onClick behavior to avoid reloading the page.

-}
linkSpa : (route -> String) -> (route -> msg) -> IconLinkSpaModel route -> Html msg
linkSpa toUrl toMsg config =
    linkBase
        [ EventExtras.onClickPreventDefaultForLinkWithHref (toMsg config.route)
            |> Attributes.fromUnstyled
        ]
        { alt = config.alt
        , url = toUrl config.route
        , icon = config.icon
        , disabled = config.disabled
        , size = config.size
        }


{-| Create an icon that links to an external site
Uses our default icon styles (25 x 25 px, azure)
-}
linkExternal : IconLinkModel -> Html msg
linkExternal =
    linkBase [ Attributes.target "_blank" ]


linkBase : List (Attribute msg) -> IconLinkModel -> Html msg
linkBase linkAttributes model =
    span
        []
        [ Html.Styled.a
            (linkAttributes ++ defaultLinkAttributes model)
            [ icon { alt = model.alt, icon = model.icon }
            ]
        ]


defaultLinkAttributes : IconLinkModel -> List (Attribute msg)
defaultLinkAttributes model =
    if model.disabled then
        [ css
            [ Css.cursor Css.notAllowed
            , linkStyles
            , sizeStyles model.size
            ]
        ]

    else
        [ css [ linkStyles, sizeStyles model.size ]
        , Attributes.href model.url
        ]


linkStyles : Style
linkStyles =
    Css.batch
        [ color Nri.Ui.Colors.V1.azure
        , display inlineBlock
        , fontFamily inherit
        , Css.property "cursor" "pointer"
        , padding zero
        , visited [ color Nri.Ui.Colors.V1.azure ]
        ]


sizeStyles : IconSize -> Style
sizeStyles size =
    Css.batch <|
        case size of
            Small ->
                [ Css.width (px 20)
                , Css.height (px 20)
                ]

            Medium ->
                [ Css.width (px 25)
                , Css.height (px 25)
                ]


{-| -}
activity : { r | activity : String } -> IconType
activity assets =
    SvgIcon assets.activity


{-| -}
add : { r | icons_plusBlue_svg : Asset } -> IconType
add assets =
    ImgIcon assets.icons_plusBlue_svg


{-| -}
arrowDown : { r | arrowDown : String } -> IconType
arrowDown assets =
    SvgIcon assets.arrowDown


{-| -}
arrowLeft : { r | leftArrowBlue_png : Asset } -> IconType
arrowLeft assets =
    ImgIcon assets.leftArrowBlue_png


{-| -}
arrowRight : { r | icons_arrowRightBlue_svg : Asset } -> IconType
arrowRight assets =
    ImgIcon assets.icons_arrowRightBlue_svg


{-| -}
assignmentStartButtonPrimary : { r | assignmentStartButtonPrimary_svg : Asset } -> IconType
assignmentStartButtonPrimary assets =
    ImgIcon assets.assignmentStartButtonPrimary_svg


{-| -}
assignmentStartButtonSecondary : { r | assignmentStartButtonSecondary_svg : Asset } -> IconType
assignmentStartButtonSecondary assets =
    ImgIcon assets.assignmentStartButtonSecondary_svg


{-| -}
assignmentTypeDiagnostic : { r | diagnostic : String } -> IconType
assignmentTypeDiagnostic assets =
    SvgIcon assets.diagnostic


{-| -}
assignmentTypePeerReview : { r | icons_peerReviewWhite_svg : Asset } -> IconType
assignmentTypePeerReview assets =
    ImgIcon assets.icons_peerReviewWhite_svg


{-| -}
assignmentTypeSelfReview : { r | icons_selfReviewWhite_svg : Asset } -> IconType
assignmentTypeSelfReview assets =
    ImgIcon assets.icons_selfReviewWhite_svg


{-| -}
assignmentTypePractice : { r | practice : String } -> IconType
assignmentTypePractice assets =
    SvgIcon assets.practice


{-| -}
assignmentTypeQuickWrite : { r | icons_quickWriteWhite_svg : Asset } -> IconType
assignmentTypeQuickWrite assets =
    ImgIcon assets.icons_quickWriteWhite_svg


{-| -}
assignmentTypeQuiz : { r | quiz : String } -> IconType
assignmentTypeQuiz assets =
    SvgIcon assets.quiz


{-| -}
assignmentTypeWritingCycle : { r | writingcycle : String } -> IconType
assignmentTypeWritingCycle assets =
    SvgIcon assets.writingcycle


{-| -}
attention : { r | attention_svg : Asset } -> IconType
attention assets =
    ImgIcon assets.attention_svg


{-| -}
bang : { r | exclamationPoint_svg : Asset } -> IconType
bang assets =
    ImgIcon assets.exclamationPoint_svg


{-| -}
bulb : { r | bulb : String } -> IconType
bulb assets =
    SvgIcon assets.bulb


{-| -}
calendar : { r | calendar : String } -> IconType
calendar assets =
    SvgIcon assets.calendar


{-| -}
caret : { r | icons_arrowDownBlue_svg : Asset } -> IconType
caret assets =
    ImgIcon assets.icons_arrowDownBlue_svg


{-| -}
checkMark : { r | iconCheck_png : Asset } -> IconType
checkMark assets =
    ImgIcon assets.iconCheck_png


{-| -}
checkMarkSquiggily : { r | squiggly_png : Asset } -> IconType
checkMarkSquiggily assets =
    ImgIcon assets.squiggly_png


{-| -}
checkMarkSvg : { r | checkmark : String } -> IconType
checkMarkSvg assets =
    SvgIcon assets.checkmark


{-| -}
class : { r | class : String } -> IconType
class assets =
    SvgIcon assets.class


{-| -}
clever : { r | clever : String } -> IconType
clever assets =
    SvgIcon assets.clever


{-| -}
clock : { r | clock : String } -> IconType
clock assets =
    SvgIcon assets.clock


{-| -}
close : { r | icons_xBlue_svg : Asset } -> IconType
close assets =
    ImgIcon assets.icons_xBlue_svg


{-| -}
copy : { r | teach_assignments_copyWhite_svg : Asset } -> IconType
copy assets =
    ImgIcon assets.teach_assignments_copyWhite_svg


{-| -}
compassSvg : { r | compass : String } -> IconType
compassSvg assets =
    SvgIcon assets.compass


{-| -}
custom : Asset -> IconType
custom asset =
    ImgIcon asset


{-| -}
darkBlueCheckMark : { r | darkBlueCheckmark_svg : Asset } -> IconType
darkBlueCheckMark assets =
    ImgIcon assets.darkBlueCheckmark_svg


{-| -}
document : { r | document : String } -> IconType
document assets =
    SvgIcon assets.document


{-| -}
download : { r | download : String } -> IconType
download assets =
    SvgIcon assets.download


{-| -}
edit : { r | edit : String } -> IconType
edit assets =
    SvgIcon assets.edit


{-| -}
editWriting : { r | editWriting : String } -> IconType
editWriting assets =
    SvgIcon assets.editWriting


{-| -}
equalitySign : { r | icons_equals_svg : Asset } -> IconType
equalitySign assets =
    ImgIcon assets.icons_equals_svg


{-| -}
exclamation : { r | exclamation : String } -> IconType
exclamation assets =
    SvgIcon assets.exclamation


{-| -}
facebook : { r | facebookBlue_svg : Asset } -> IconType
facebook assets =
    ImgIcon assets.facebookBlue_svg


{-| -}
flag : { r | iconFlag_png : Asset } -> IconType
flag assets =
    ImgIcon assets.iconFlag_png


{-| -}
flipper : { r | flipper : String } -> IconType
flipper assets =
    SvgIcon assets.flipper


{-| -}
footsteps : { r | footsteps : String } -> IconType
footsteps assets =
    SvgIcon assets.footsteps


{-| -}
gardening : { r | startingOffBadge_png : Asset } -> IconType
gardening assets =
    ImgIcon assets.startingOffBadge_png


{-| -}
gear : { r | gear : String } -> IconType
gear assets =
    SvgIcon assets.gear


{-| -}
greenCheckMark : { r | smallCheckmark_png : Asset } -> IconType
greenCheckMark assets =
    ImgIcon assets.smallCheckmark_png


{-| -}
guidedWrite : { r | icons_guidedWrite_svg : Asset } -> IconType
guidedWrite assets =
    ImgIcon assets.icons_guidedWrite_svg


{-| -}
hat : { r | hat : String } -> IconType
hat assets =
    SvgIcon assets.hat


{-| -}
help : { r | icons_helpBlue_svg : Asset } -> IconType
help assets =
    ImgIcon assets.icons_helpBlue_svg


{-| -}
helpSvg : { r | help : String } -> IconType
helpSvg assets =
    SvgIcon assets.help


{-| -}
highFive : { r | level3Badge_png : Asset } -> IconType
highFive assets =
    ImgIcon assets.level3Badge_png


{-| -}
key : { r | key : String } -> IconType
key assets =
    SvgIcon assets.key


{-| -}
keychain : { r | keychain : String } -> IconType
keychain assets =
    SvgIcon assets.keychain


{-| -}
late : { r | icons_clockRed_svg : Asset } -> IconType
late assets =
    ImgIcon assets.icons_clockRed_svg


{-| -}
leaderboard : { r | leaderboard : String } -> IconType
leaderboard assets =
    SvgIcon assets.leaderboard


{-| -}
lightBulb : { r | hint_png : Asset } -> IconType
lightBulb assets =
    ImgIcon assets.hint_png


{-| -}
lock : { r | lock : String } -> IconType
lock assets =
    SvgIcon assets.lock


{-| -}
lockDeprecated : { r | premiumLock_svg : Asset } -> IconType
lockDeprecated assets =
    ImgIcon assets.premiumLock_svg


{-| -}
logo : { r | logoRedBlack_svg : Asset } -> IconType
logo assets =
    ImgIcon assets.logoRedBlack_svg


{-| -}
masteryBadge : { r | masteryBadge : String } -> IconType
masteryBadge assets =
    SvgIcon assets.masteryBadge


{-| -}
newspaper : { r | newspaper : String } -> IconType
newspaper assets =
    SvgIcon assets.newspaper


{-| -}
notStarred : { r | commentNotStarred_png : Asset } -> IconType
notStarred assets =
    ImgIcon assets.commentNotStarred_png


{-| -}
okay : { r | level2Badge_png : Asset } -> IconType
okay assets =
    ImgIcon assets.level2Badge_png


{-| -}
openClose : { r | openClose : String } -> IconType
openClose assets =
    SvgIcon assets.openClose


{-| -}
peerReview : { r | icons_peerReview_svg : Asset } -> IconType
peerReview assets =
    ImgIcon assets.icons_peerReview_svg


{-| -}
pen : { r | pen : Asset } -> IconType
pen assets =
    ImgIcon assets.pen


{-| -}
performance : { r | performance : String } -> IconType
performance assets =
    SvgIcon assets.performance


{-| -}
personBlue : { r | personBlue_svg : Asset } -> IconType
personBlue assets =
    ImgIcon assets.personBlue_svg


{-| -}
preview : { r | preview : String } -> IconType
preview assets =
    SvgIcon assets.preview


{-| -}
quickWrite : { r | icons_quickWrite_svg : Asset } -> IconType
quickWrite assets =
    ImgIcon assets.icons_quickWrite_svg


{-| -}
seeMore : { r | seemore : String } -> IconType
seeMore assets =
    SvgIcon assets.seemore


{-| -}
share : { r | share : String } -> IconType
share assets =
    SvgIcon assets.share


{-| -}
skip : { r | skip : String } -> IconType
skip assets =
    SvgIcon assets.skip


{-| -}
sort : { r | sort : String } -> IconType
sort assets =
    SvgIcon assets.sort


{-| -}
sortArrow : { r | sortArrow : String } -> IconType
sortArrow assets =
    SvgIcon assets.sortArrow


{-| -}
speedometer : { r | speedometer : String } -> IconType
speedometer assets =
    SvgIcon assets.speedometer


{-| -}
starred : { r | commentStarred_png : Asset } -> IconType
starred assets =
    ImgIcon assets.commentStarred_png


{-| -}
thumbsUp : { r | level1Badge_png : Asset } -> IconType
thumbsUp assets =
    ImgIcon assets.level1Badge_png


{-| -}
twitter : { r | twitterBlue_svg : Asset } -> IconType
twitter assets =
    ImgIcon assets.twitterBlue_svg


{-| -}
unarchive : { r | unarchiveBlue2x_png : Asset } -> IconType
unarchive assets =
    ImgIcon assets.unarchiveBlue2x_png


{-| -}
writingAssignment : { r | writingAssignment : String } -> IconType
writingAssignment assets =
    SvgIcon assets.writingAssignment


{-| -}
x : { r | xWhite_svg : Asset } -> IconType
x assets =
    ImgIcon assets.xWhite_svg


{-| -}
xSvg : { r | x : String } -> IconType
xSvg assets =
    SvgIcon assets.x


{-| -}
submitting : { r | submitting : String } -> IconType
submitting assets =
    SvgIcon assets.submitting


{-| -}
rating : { r | rating : String } -> IconType
rating assets =
    SvgIcon assets.rating


{-| -}
revising : { r | revising : String } -> IconType
revising assets =
    SvgIcon assets.revising


{-| Inlining SVG styles because styles.class doesn't work on SVG elements.
The `className` property of an SVG element isn't a string, it's an object and so
`styles.class` causes a runtime exception by attempting to overwrite it with
a string. Another workaround is to use the `Svg.Attributes.class` attribute but
since `withNamespace` hides a call to `Html.Attributes.class` we can't do it
properly.
-}
svgStyle : List (RootHtml.Attribute msg)
svgStyle =
    [ RootAttr.style "fill" "currentColor"
    , RootAttr.style "width" "100%"
    , RootAttr.style "height" "100%"
    ]
