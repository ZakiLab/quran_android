import QtQuick 2.0

Rectangle {
    id: splash
    color: "black"
    anchors.fill :parent;

    Image {
        id: splashImage
        anchors.centerIn: parent;
        width: master.small;
        height: master.small;
        source :"content/imgs/quransplash.jpg";
        /*
        MouseArea {
            anchors.fill: parent;
            onClicked: window.source="../pages.qml";
        }
        */
    }
    //Timer {
    //    interval: 1500; running: true; repeat: false
    //    onTriggered: window.source = "pages.qml";
    //}
}
