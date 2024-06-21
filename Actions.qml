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
    property alias zoomFitWidth: _zoomFitWidth
    property alias zoomFitBest: _zoomFitBest
    property alias zoomOriginal: _zoomOriginal

    //工具
    property alias drawerAction: _drawerAction //侧边栏
    property alias selectAll: _selectAll
    property alias copy: _copy
    property alias addmarks: _addmarks

    //文件
    Action {
        id: _open
        text: "打开(O)"  //用于打开文件
        icon.name: "document-open"
        shortcut: "Ctrl+O"
        //StandardKey.Open  //一般是Ctrl + O"
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
        shortcut: StandardKey.ZoomIn  //一般是Ctrl + "+"  //经测试不是这个组合,而是Ctrl + shift + "+"
        enabled: _pdfMultiView.renderScale < 10   //当符合条件时，此动作才是可用的（其实就是设置了缩放的上限即最大）
        onTriggered: _pdfMultiView.renderScale *= 1.1  //每次在原有的比例上放大1.1倍数
    }
    Action {
        id: _zoomOut   //一般是 Ctrl + ”-“
        text: "缩小"
        icon.name: "zoom-out"
        shortcut: StandardKey.ZoomOut
        enabled: _pdfMultiView.renderScale > 0.1   //当符合条件时，此动作才是可用的（其实就是设置了缩放的下限即最小）
        onTriggered: _pdfMultiView.renderScale /= 1.1
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
    Action {
        id:_zoomFitWidth
        text: "适应宽度"
        icon.name: "zoom-fit-width"
        onTriggered: _pdfMultiView.scaleToWidth(appwindow.contentItem.width, appwindow.contentItem.height)
    }
    Action{
        id:_zoomFitBest
        text: "适应整页"
        icon.name: "zoom-fit-best"
        onTriggered: _pdfMultiView.scaleToPage(appwindow.contentItem.width, appwindow.contentItem.height)
    }
    Action{
        id:_zoomOriginal
        text: "初始化缩放"
        icon.name: "zoom-fit-original"
        onTriggered: _pdfMultiView.resetScale()
    }

    //工具
    Action {
        id: _drawerAction
        // text: "侧边栏"
        icon.name: "sidebar-expand-left"
        onTriggered: content.drawer.open()
    }
    Action{
        id:_selectAll
        text:"全选"
        icon.name: "edit-select-all-symbolic"
        onTriggered: _pdfMultiView.selectAll()
    }
    Action{
        id:_copy
        text: "复制"
        icon.name: "edit-copy-symbolic"
        enabled: _pdfMultiView.selectedText !== ""
        onTriggered: _pdfMultiView.copySelectionToClipboard()
    }
    Action {
        id: _addmarks
        text: qsTr("添加书签")
        icon.name: "bookmark-new"
    }
}
