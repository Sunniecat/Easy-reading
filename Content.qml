import QtQuick
import QtQuick.Pdf

Rectangle {
    property alias pdfdoc: _pdfdoc
    property alias dialogs: _dialogs

    PdfDocument {
        id: _pdfdoc
    }
    Dialogs {
        id: _dialogs

    }
}
