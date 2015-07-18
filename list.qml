import QtQuick.LocalStorage 2.0
import QtQuick 2.0
import "content/gestion.js" as MyJs
import QtGraphicalEffects 1.0


Rectangle {
    id: mainliste
    anchors.fill: parent
    color :"#FFFFFF";
    //color :Qt.rgba(0, 0, 0, 1);
    Image{
        id : backlist;
        width: parent.width;
        onWidthChanged: { backlist.y = MyJs.defaulty();}
        height: (sourceSize.height/sourceSize.width)* parent.width;
        x: 0;
        y: main.defaulty;
        source: "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/" + window.page + ".zlp";
        asynchronous: true;
        smooth : true;
    }
    GaussianBlur {
            anchors.fill: backlist
            source: backlist
            radius: 16
            samples: 32
        }
    //property int times: window.bookmarknum;
    Rectangle {
        id: mainlistein
        anchors.fill: parent
        color :Qt.rgba(0, 0, 0, 0.7);
    //index listeview
    ListView{
        id: indexliste
        width: parent.width - (80*master.scale);
        height: parent.height;
        x:0;y:0;
        model : IndexModel{}
        header : bookmark
        //highlight: selector;
        //highlightFollowsCurrentItem: true;
        focus: true;
        delegate: IndexDelegate {}
        footer: Rectangle {width: parent.width; height: 50*master.scale; color:"transparent"}
    }
    //bookmark
    Component {id:bookmark

        Column {
            id:bookmarkcolumn
            Rectangle{
                id:videupindex
                width: indexliste.width
                height: 60*master.scale;//to be changed
                color:"transparent"
                //anchors.top : mainliste.top;
            }
            Repeater{
                id:bookmarkrepeater
                model: window.bookmarknum//mainliste.times;//2//window.bookmarknum;
                // Al hamdou li Allah
                Rectangle{
                    id:bookmarkelement
                    width: indexliste.width
                    height: 70*master.scale; ///a changer dinamiquement
                    color: "transparent"
                    property int img : MyJs.listestartup(index,"img")
                    property string name : MyJs.listestartup(index,"en")
                    property int pge : MyJs.listestartup(index,"page");
                    property int yy: (index * 70 * master.scale )+ (60*master.scale);
                    Image {
                        id: bookmarklogo
                        source: "content/imgs/book.png"
                        width: sourceSize.width*master.scale;
                        height: sourceSize.height*master.scale;
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Image {
                        id: bookmarksourat
                        source: "content/imgs/index/"+ bookmarkelement.img +".png" //javascript avec conteur d index
                        width: sourceSize.width*master.scale;
                        height: sourceSize.height*master.scale;
                        anchors.right: bookmarklogo.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 5
                    }
                    Text {
                        id: bookmarksouratlatin
                        text: bookmarkelement.name
                        font.pointSize: Math.ceil(9*master.scale);
                        font.weight: Font.Bold
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.verticalCenter: parent.verticalCenter//sourat
                        anchors.verticalCenterOffset: -10
                        color :"white"
                    }
                    Text {
                        id: bpage
                        text: "page: "+ (bookmarkelement.pge - 3);
                        color : "#FFFFFF"
                        anchors.top: bookmarksouratlatin.bottom
                        anchors.left:  parent.left
                        anchors.leftMargin: 20
                        font.pointSize: Math.ceil(7*master.scale);
                    }
                    MouseArea {
                        id : favmouse
                        anchors.fill: parent;
                        onClicked: {
                            window.page = bookmarkelement.pge;
                            window.source = "pages.qml";
                        }/*
                        onPressAndHold: {
                            MyJs.delatebookmark(bookmarkelement.pge,bookmarkelement.img,bookmarkelement.name);
                            bpage.destroy();
                            bookmarksouratlatin.destroy();
                            bookmarksourat.destroy();
                            bookmarklogo.destroy();
                            bookmarkelement.width = 0;
                        }*/
                    }
                }
            }
            // separation image
            Image {
                id: separation
                source: "content/imgs/sep_w.png"
                anchors.right: bookmarkcolumn.right
                width: sourceSize.width*master.scale;
                height: sourceSize.height*master.scale;
                anchors.rightMargin: 30
            }
        }
    }

    //jouze listeview
    ListView{id: jouze
        width: 70*master.scale;
        height: parent.height;
        y:0; x: parent.width - jouze.width;
        model : JuzeModel {}
        header : Rectangle { width: jouze.width; height: 40*master.scale; color:"transparent" }
        delegate: JuzeDelegate {}
        footer: Rectangle {width: parent.width; height: 50*master.scale; color:"transparent"}
    }

    //tool bar
    Rectangle{
        id: header
        width:parent.width
        height: 60*master.scale;
        anchors.top: parent.top;
        gradient: Gradient {
                 GradientStop { position: 0.25; color: "black" }
                 GradientStop { position: 1.0; color: "transparent" } //"transparent"
        }
        Image {
            id: settingbtn
            source: "content/imgs/setting.png"
            anchors.top:parent.top;
            anchors.right: parent.right;
            anchors.rightMargin: 17
            width: sourceSize.width*master.scale;
            height: sourceSize.height*master.scale;
            opacity: sttingbtnmouse.pressed ? 0.3 :1;
            MouseArea{
                id:sttingbtnmouse
                anchors.fill: parent;
                onClicked: window.source = "settings.qml";
            }
        }/*
        Image {
            id: lastpage
            source: "content/imgs/page.png"
            x:((mainliste.width*3)/4) - (50*master.scale) ;
            y:0
            width: sourceSize.width*master.scale;
            height: sourceSize.height*master.scale;
            opacity: lastpagemouse.pressed ? 0.3 :1;
            MouseArea{
                id: lastpagemouse
                anchors.fill: parent;
                onClicked: { window.source = "pages.qml";}
                //onClicked: { menuwindow.z = 2;master.mouse = true;}
            }
        }*/

    }
    // fade bottom
    Rectangle{
        id: footer
        width:parent.width
        height: 60*master.scale;
        anchors.bottom: parent.bottom;
        gradient: Gradient {
                 GradientStop { position: 1.0; color: "black" }
                 GradientStop { position: 0.0; color: "transparent" }
        }
    }


    }

}

