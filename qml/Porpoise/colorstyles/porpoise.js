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
        animationDuration: 150
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
            normal: "#545351",
            hover: "#545351"
        },
        // The last crumb (without and ">") is drawn in this color
        fontColorActive: {
            normal: "#545351",
            hover: "#545351"
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
        normal: "#C4C3C1",
        hover: "#C4C3C1",
        pointSize: 15
    },
    // These settings are all ements inside a view container. This could be the icon view, list view, tree view. All of them.
    // View specifics as in how the icon view should be spaced or how list view should be spaced is - for now - determined in the actual views.
    ViewContainer: {
        fileExtension: {
            visible: true,
            color: "red"
        },
        contentStates: {
            normal: {
                color: "#676664",
                duration: 150
            },
            hover: {
                color: "#E05B3C",
                duration: 150
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
                color: "transparent"
            },
            hover: {
                color: "#F9EBE8",
                borderColor: "#F0E2DF"
            }
        }
    }
}