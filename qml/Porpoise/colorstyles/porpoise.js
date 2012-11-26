.pragma library
// Please do note that the settings below are DEFAUTS. Some of them should be adjustable on the application side without editing this file. Probably through KConfig.
// And for that to work properly, a KConfig QML (or JavaScript) wrapper probably has to be created.

// This file - or any style files - should NEVER be accessed directly in the QML files!

var Style = {
    // These values under "Application" are application defaults. If the specific settings don't set a value then the application default is used.
    Application: {
        background: {
            color: "#FCFBF9"
        },
        font: {
            color: "#545351"
        },
        divider: {
            color: "#E5E4E2"
        },

        animationDuration: 150
    },
    LeftContainer: {
        width: 175
    },
    BreadCrumb: {
        background: {
            normal: "transparent",
            hover: "transparent"
        },
        font: {
            pointSize: 12
        },
        // All crumbs but the last one are drawn in this color
        fontColorInactive: {
            normal: "#A4A3A1",
            hover: "#E79685"
        },
        // The last crumb (without and ">") is drawn in this color
        fontColorActive: {
            normal: "#676664",
            hover: "#E05B3C"
        },
        iconColor: {
            normal: "#C4C3C1",
            hover: "#C4C3C1"
        },
        iconRotationStates: {
            normal: {
                rotation: 0,
                duration: 150
            },
            rotateDown: {
                rotation: 90,
                duration: 150
            }
        },
    },
    // These are the buttons before and after the breadcrumb
    ToolButtons: {
        normal: "#676664",
        hover: "#E05B3C",
        disabledColor: "#A4A3A1",
        pointSize: 15
    },
    // These settings are all ements inside a view container. This could be the icon view, list view, tree view. All of them.
    // View specifics as in how the icon view should be spaced or how list view should be spaced is - for now - determined in the actual views.
    ViewContainer: {
        FileExtension: {
            visible: true,
            color: "red"
        },
        ContentStates: {
            normal: {
                highlight: "#676664",
                color: "#A4A3A1",
                duration: 150
            },
            hover: {
                highlight: "#E05B3C",
                color: "#E79685",
                duration: 150
            }
        },
        HeaderNames: {
            normal: {
                color: "#676664",
            },
            hover: {
                color: "#E05B3C",
            }
        },
        // The default item settings excluding clolors.
        Item: {
            border: 1,
            roudedCorners: 3
        },
        // The color specifics based on state
        ItemStates: {
            normal: {
                color: "transparent",
                borderColor: "transparent",
                imageBorderColor: "#EFE9EB",
                imageBackground: "#FFFEFF"
            },
            hover: {
                color: "#F9EBE8",
                borderColor: "#F0E2DF",
                imageBorderColor: "#F0E2DF",
                imageBackground: "#FFFCFD"
            }
        }
    }
}
