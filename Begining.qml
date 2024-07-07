//this part is the initial content of the interface, and the content displayed after the file closed
//it can open a new file or open a recent file or clear all recent files
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "controller.js" as Controller

Rectangle{
    property alias recentfileslist: _recentfileslist
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
            background: Rectangle{
                color: "lightgrey"
                border.color: "grey"
                border.width: 1
            }
            anchors.bottom: txt.bottom
            onClicked: Controller.openfile()
        }
    }
    Rectangle{
        id: rightpart  //it is used to show the text of right part, include "最近打开" and "清楚所有"
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
        Button{
            icon.name: "edit-clear-history"
            text: qsTr("清楚所有")
            font.pointSize: 10
            height: 30
            width: 100
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle{color: "lightgrey"}
            onClicked: {
                Controller.clearAllRecentfiles()
                console.log("clear recentfiles list, count: ", recentfileslist.count)
            }
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
            id: _recentfileslist
            height: parent.height
            width: parent.width
            model: recentfiles.recentFiles
            delegate: MenuItem {
                text: recentfiles.displayableFilePath(modelData)
                onTriggered: {
                    let filepath = modelData
                    Controller.loadFile(filepath)
                    console.log("clicked: ", filepath)
                }
                TapHandler{
                    acceptedButtons: Qt.RightButton
                    onTapped: {
                        console.log("cliced rightbutton")
                        recentfileslist.currentIndex = index
                        console.log("recentfileslist.currentIndex: ", recentfileslist.currentIndex)
                        console.log("index: ", index)
                        rightbuttonMenu.popup()
                    }
                }
            }
        }  //ListView finish

        Menu{
            id: rightbuttonMenu  //click the right button of mouse on recent file, then pop up a menu
            MenuItem{
                text: "忘记此项(F)"
                icon.name: "edit-clear-history"
                onTriggered: {
                    console.log("clicked 忘记此项")
                    let index = recentfileslist.currentIndex
                    Controller.removeRecentfile(index)
                    console.log("forget index: ", index)
                }
            }
        }

    }
}
