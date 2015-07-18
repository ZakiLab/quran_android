import QtQuick 2.0
import "content/gestion.js" as MyJs

Item {
    id: indexdelegate
    width: parent.width
    height: 70*master.scale;
        Rectangle{
            id:row1
            anchors.fill: parent
            color :"transparent"
            Image {
                id: souratimg
                source: "content/imgs/index/" + img
                height: sourceSize.height*master.scale;
                width: sourceSize.width*master.scale;
                anchors.right: parent.right;
                asynchronous: true;
            }
            Text {
                id: souratlatin
                text: sourat
                font.pointSize: Math.ceil(9*master.scale);
                font.weight: Font.Bold
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    window.page = MyJs.pages[index];
                    window.source = "pages.qml";
                }
                onPressed: indexliste.currentIndex = index;

            }
        }
}
