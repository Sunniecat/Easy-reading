import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQuick.Pdf

Item {
    property alias fileOpen: _fileOpen

    //打开pdf文件窗口
    FileDialog{
        id: _fileOpen
        title: "Open a PDF file"
        nameFilters: [ "PDF files (*.pdf)" ]
    }
}
