// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
Item {
    id: juze
    width : 60*master.scale;
    height: 220*master.scale;
    Image {
        id: juzebg
        source: "content/imgs/jouze_w.png"
        anchors.fill: parent;
        asynchronous: true;
        Text {
            id: juzenum
            color: "#ffffff"
            text: numjuze;
            font.pointSize: Math.ceil(8*master.scale);
            anchors.top: parent.top
            anchors.topMargin: 35*master.scale;
            anchors.horizontalCenter: parent.horizontalCenter
        }
        MouseArea{
            id : juzemouse1
            width: parent.width;
            height: 90*master.scale;
            anchors.top: juzebg.top
            onClicked: { window.page = page1 ; window.source =  "pages.qml"}
        }
        MouseArea{
            id : juzemouse2
            x: 5
            y: 90*master.scale;
            width: 50*master.scale;
            height: 40*master.scale;
            anchors.horizontalCenter: juzebg.horizontalCenter
            anchors.top: juzemouse1.bottom;
            anchors.topMargin: 0
            onClicked: { window.page = page2 ; window.source =  "pages.qml"}
        }
        MouseArea{
            id : juzemouse3
            width: 50*master.scale;
            height: 40*master.scale;
            anchors.horizontalCenter: juzebg.horizontalCenter
            anchors.top: juzemouse2.bottom;
            anchors.topMargin: 5
            onClicked: { window.page = page3 ; window.source =  "pages.qml"}
        }
        MouseArea{
            id : juzemouse4
            width: 50*master.scale;
            height: 34*master.scale;
            anchors.horizontalCenter: juzebg.horizontalCenter
            anchors.top: juzemouse3.bottom;
            anchors.topMargin: 5
            onClicked: { window.page = page4 ; window.source =  "pages.qml"}
        }
    }
}
