import QtQuick
import QtQuick.Controls


Item {
    //文件
    property  alias open: _open
    property alias save: _save
    property alias about: _about
    //视图
    property alias zoomIn: _zoomIn
    property alias zoomOut: _zoomOut
    property alias rotateLeft: _rotateLeft
    property alias rotateRight: _rotateRight

    //文件
    Action {
        id: _open
        text: "打开(O)"  //用于打开文件
        icon.name: "document-open"
        shortcut: StandardKey.Open  //一般是Ctrl + O
        // onTriggered:
    }
    Action {
        id: _save
        text: "保存(S)"   //用于做了修改后（比如做了批注等）保存
        icon.name: "document-save"
        shortcut: StandardKey.Save   //一般是Ctrl + S
        // onTriggered:
    }
    Action {
        id: _about
        text: "关于"  //一些关于此阅读器的介绍等
        icon.name: "help-about"
        // onTriggered:
    }

    //视图
    Action {
        id: _zoomIn
        text: "放大"
        icon.name: "zoom-in"
        shortcut: StandardKey.ZoomIn  //一般是Ctrl + "-"
        onTriggered:view.renderScale*=Math.sqrt(2)
    }
    Action {
        id: _zoomOut   //一般是 Ctrl + ”+“
        text: "缩小"
        icon.name: "zoom-out"
        shortcut: StandardKey.ZoomOut
         onTriggered: view.renderScale /= Math.sqrt(2)
    }
    Action {
        id:_rotateLeft
        text: "向左旋转"
        icon.name: "object-rotate-left-symbolic"
        shortcut: "Ctrl+L"
    }
    Action {
        id:_rotateRight
        text: "向右旋转"
        icon.name: "object-rotate-right-symbolic"
        shortcut: "Ctrl+R"
    }
}
