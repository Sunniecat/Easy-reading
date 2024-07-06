import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "controller.js" as Controller

Rectangle{
    color: "lightgrey"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    width: 600
    height: 400
    Rectangle{
        id: txt
        width: parent.width*0.35
        height: parent.height*0.5
        color: "lightgrey"
        anchors.verticalCenter: parent.verticalCenter

        Rectangle{
            id: t1
            width: 200
            height: 50
            color: "lightgrey"
            Text {
                text: qsTr("欢迎使用")
                anchors.fill: parent
                fontSizeMode: Text.FixedSize
                font.pointSize: 18
            }
        }
        Rectangle{
            id: t2
            width: 200
            height: 50
            anchors.top: t1.bottom
            color: "lightgrey"
            Text {
                text: qsTr("Easy reading")
                anchors.fill: parent
                fontSizeMode: Text.FixedSize
                font.pointSize: 20
            }
        }
        Button{
            icon.name: "document-open"
            text: qsTr("打开文档")
            font.pointSize: 10
            height: 30
            width: 100
            Rectangle{color: "grey"}
            anchors.bottom: txt.bottom
        }
    }
    Rectangle{
        id: rightpart
        width: parent.width*0.65
        height: 60
        color: "lightgrey"
        anchors.left: txt.right
        Text {
            text: qsTr("最近打开")
            fontSizeMode: Text.FixedSize
            font.pointSize: 16
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: qsTr("清楚所有")
            fontSizeMode: Text.FixedSize
            font.pointSize: 13
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle{
        id: showrecentfiles
        width: parent.width*0.65
        height: parent.height-rightpart.height
        anchors.left: txt.right
        anchors.top: rightpart.bottom
        border.color: "grey"
        border.width: 1
        ListView{
            id: recentfileslist
            height: parent.height
            width: parent.width
            model: recentfiles.recentFiles
            delegate: MenuItem {
                text: recentfiles.displayableFilePath(modelData)
                onTriggered: {
                    Controller.loadFile(modelData)
                    console.log("clicked: ", modelData)
                }
            }

        }

    }
}
