pragma Singleton
import QtQuick

QtObject {
    // Base tokens
    readonly property int spacingXs: 4
    readonly property int spacingSm: 6
    readonly property int spacingMd: 8
    readonly property int radiusSm: 6
    readonly property int radiusMd: 8
    readonly property int radiusPill: 16
    readonly property int fontSizeSm: 13
    readonly property int fontSizeMd: 16

    // Bar
    readonly property int barHeight: 42
    readonly property int barPadding: spacingSm
    readonly property color barBackgroundColor: Colors.mantle

    // Clock
    readonly property int clockFontPixelSize: fontSizeMd
    readonly property int clockHorizontalPadding: workspaceInnerPaddingLeft + workspaceInnerPaddingRight
    readonly property int clockBorderRadius: radiusPill
    readonly property color clockBackgroundColor: Colors.surface0
    readonly property color clockTimeTextColor: Colors.blue
    readonly property color clockDateTextColor: Colors.maroon

    // System power
    readonly property int systemPowerFontPixelSize: clockFontPixelSize + 2
    readonly property int systemPowerHorizontalPadding: clockHorizontalPadding
    readonly property int systemPowerBorderRadius: clockBorderRadius
    readonly property color systemPowerBackgroundColor: clockBackgroundColor
    readonly property color systemPowerIconColor: Colors.maroon
    readonly property int systemPowerMenuOffsetY: 8
    readonly property int systemPowerMenuWidth: 160
    readonly property int systemPowerMenuItemHeight: 34
    readonly property int systemPowerMenuItemHorizontalPadding: 12
    readonly property int systemPowerMenuSpacing: 4
    readonly property int systemPowerMenuRadius: radiusMd
    readonly property color systemPowerMenuBackgroundColor: Colors.surface0
    readonly property color systemPowerMenuTextColor: Colors.text
    readonly property color systemPowerMenuHoverColor: Colors.surface1
    readonly property color systemPowerMenuSeparatorColor: Colors.overlay0

    // Keyboard state
    readonly property int keyboardPollIntervalMs: 300
    readonly property int keyboardFontPixelSize: clockFontPixelSize
    readonly property int keyboardHorizontalPadding: clockHorizontalPadding
    readonly property int keyboardBorderRadius: clockBorderRadius
    readonly property color keyboardBackgroundColor: clockBackgroundColor
    readonly property color keyboardOffTextColor: Colors.blue
    readonly property color keyboardOnTextColor: Colors.maroon

    // Media
    readonly property int mediaPollIntervalMs: 1000
    readonly property int mediaFontPixelSize: clockFontPixelSize
    readonly property int mediaHorizontalPadding: clockHorizontalPadding
    readonly property int mediaBorderRadius: clockBorderRadius
    readonly property int mediaMaxTextWidth: 280
    readonly property color mediaBackgroundColor: clockBackgroundColor
    readonly property color mediaTextColor: Colors.text
    readonly property color mediaIconColor: Colors.blue
    readonly property string mediaIcon: "󰎈"

    readonly property int mediaMenuOffsetY: 8
    readonly property int mediaMenuWidth: 260
    readonly property int mediaMenuItemHeight: 34
    readonly property int mediaMenuItemHorizontalPadding: 12
    readonly property int mediaMenuItemVerticalPadding: 8
    readonly property int mediaMenuSpacing: 4
    readonly property int mediaMenuRadius: radiusMd
    readonly property color mediaMenuBackgroundColor: Colors.surface0
    readonly property color mediaMenuMetaBackgroundColor: Colors.surface1
    readonly property color mediaMenuTextColor: Colors.text
    readonly property color mediaMenuSubtleTextColor: Colors.subtext1
    readonly property color mediaMenuHoverColor: Colors.surface1
    readonly property int mediaControlButtonSize: 30
    readonly property int mediaControlButtonSpacing: spacingSm
    readonly property int mediaControlIconPixelSize: 16
    readonly property color mediaControlButtonColor: Colors.surface1
    readonly property color mediaControlButtonHoverColor: Colors.surface2
    readonly property color mediaControlIconColor: Colors.text
    readonly property string mediaPreviousIcon: "󰒮"
    readonly property string mediaPlayIcon: "󰐊"
    readonly property string mediaPauseIcon: "󰏤"
    readonly property string mediaStopIcon: "󰓛"
    readonly property string mediaNextIcon: "󰒭"

    // Volume
    readonly property int volumePollIntervalMs: 300
    readonly property int volumeFontPixelSize: clockFontPixelSize
    readonly property int volumeHorizontalPadding: clockHorizontalPadding
    readonly property int volumeBorderRadius: clockBorderRadius
    readonly property color volumeBackgroundColor: clockBackgroundColor
    readonly property color volumeTextColor: Colors.text
    readonly property color volumeIconColor: Colors.blue
    readonly property color volumeMutedTextColor: Colors.maroon
    readonly property color volumeMutedIconColor: Colors.maroon
    readonly property int volumeWheelStepPercent: 2
    readonly property string volumeOutputIcon: "󰕾"
    readonly property string volumeOutputMutedIcon: "󰖁"
    readonly property string volumeInputIcon: "󰍬"
    readonly property string volumeInputMutedIcon: "󰍭"
    readonly property int volumeMenuOffsetY: 8
    readonly property int volumeMenuWidth: 96
    readonly property int volumeMenuSpacing: spacingSm
    readonly property int volumeMenuRadius: radiusMd
    readonly property int volumeMenuSliderWidth: 24
    readonly property int volumeMenuSliderHeight: 120
    readonly property int volumeMenuIconPixelSize: fontSizeMd
    readonly property color volumeMenuBackgroundColor: Colors.surface0
    readonly property color volumeMenuSliderTrackColor: Colors.surface2
    readonly property color volumeMenuSliderFillColor: Colors.blue
    readonly property color volumeMenuTextColor: Colors.text

    // Window title
    readonly property int windowTitleMinWidth: 140
    readonly property int windowTitleMaxWidth: 420
    readonly property int windowTitlePollIntervalMs: 250
    readonly property color windowTitleTextColor: Colors.blue

    // Workspaces
    readonly property int workspaceOuterMargin: 5
    readonly property int workspaceInnerPaddingLeft: 16
    readonly property int workspaceInnerPaddingRight: 16
    readonly property int workspaceRadius: radiusPill
    readonly property int workspaceButtonRadius: radiusPill
    readonly property int workspaceButtonPadding: 6
    readonly property int workspaceButtonSpacing: spacingXs
    readonly property int workspaceFontPixelSize: fontSizeSm
    readonly property int workspacePollIntervalMs: 300
    readonly property color workspaceBackgroundColor: Colors.surface0
    readonly property color workspaceTextColor: Colors.blue
    readonly property color workspaceActiveTextColor: Colors.maroon
    readonly property color workspaceHoverTextColor: Colors.sapphire

    // Battery
    readonly property int batteryFontPixelSize: fontSizeSm
    readonly property int batteryHorizontalPadding: 10
    readonly property int batteryRadius: radiusSm
    readonly property color batteryBackgroundColor: Colors.surface0
    readonly property color batteryTextColor: Colors.text
    readonly property color batteryLowTextColor: Colors.red

    // Network
    readonly property int networkFontPixelSize: fontSizeSm
    readonly property int networkHorizontalPadding: 10
    readonly property int networkRadius: radiusSm
    readonly property color networkBackgroundColor: Colors.surface0
    readonly property color networkTextColor: Colors.text
    readonly property color networkDisconnectedTextColor: Colors.maroon
}
