import QtQuick 2.0
import "content/gestion.js" as MyJs

Rectangle {
    id: mainliste
    anchors.fill: parent
    color :"transparent";

    Rectangle{
        id:bookmangment;
        width: mainliste.width - 30;
        height: 60
        color: window.color;
        radius: 10
        y : -60
        anchors.horizontalCenter: mainliste.horizontalCenter;
        state: "bookoff"
        z:10
        MouseArea{
        anchors.fill: parent;
        onClicked: bookmangment.state = "bookoff"
        }
        Text {
            width: parent.width - 30
            anchors.centerIn: parent
            id: bookmangmenttext
            text: "press and hold on a bookmark to delete it"
            wrapMode : Text.Wrap;
            color: "white";

        }
        states: [
            State {
                name: "bookon"
                PropertyChanges {
                    target: bookmangment
                    y: 100;
                }
            },
            State {
                name: "bookoff"
                PropertyChanges {
                    target: bookmangment
                    y : -60;
                }
            }

        ]
        transitions :[
            Transition { to : "bookon";
                        NumberAnimation { properties: "y"; duration: 200 }
                    },
            Transition { to : "bookoff";
                        NumberAnimation { properties: "y"; duration: 200 }
                    }
        ]

    }
    //property int times: window.bookmarknum;
    Component.onCompleted: {MyJs.mapage(window.page);}
    VisualItemModel{
        id: itemModel
        Image {
            id: liste
            source: "content/imgs/listebg.png"
            width:mainliste.width;

            height: mainliste.height
            //index listeview
            ListView{
                id: indexliste
                width: parent.width - 80;
                height: parent.height;
                x:0;y:0;
                model : IndexModel {}
                header : bookmark
                highlight: selector;
                highlightFollowsCurrentItem: true;
                focus: true;
                delegate: IndexDelegate {}
                footer: Rectangle {width: parent.width; height: 50; color:"transparent"}
            }
            Component{id:selector;
                Rectangle{
                    //y: indexliste.currentItem.y
                    width: indexliste.width;
                    height: 70;
                    radius: 16;
                    gradient: Gradient {
                             GradientStop { position: 0.0; color: "transparent" }
                             GradientStop { position: 0.25; color: window.color; }
                             GradientStop { position: 1.0; color: "transparent" }
                    }
                }

            }
            //bookmark
            Component {id:bookmark

                Column {
                    id:bookmarkcolumn
                    Rectangle{
                        id:videupindex
                        width: indexliste.width
                        height: 60
                        color:"transparent"
                        //anchors.top : mainliste.top;
                    }
                    Repeater{
                        id:bookmarkrepeater
                        model: window.bookmarknum//mainliste.times;//2//window.bookmarknum;
                        // ya rabi zawjna
                        Rectangle{
                            id:bookmarkelement
                            width: indexliste.width
                            height: 70 ///a changer dinamiquement
                            //color: "transparent"
                            radius: 16;
                            gradient: Gradient {
                                     GradientStop { position: 0.0; color: "transparent" }
                                     GradientStop { position: 0.25; color: favmouse.pressed ? window.color : "transparent"; }
                                     GradientStop { position: 1.0; color: "transparent" }
                            }
                            property int img : MyJs.listestartup(index,"img")
                            property string name : MyJs.listestartup(index,"en")
                            property int pge : MyJs.listestartup(index,"page");
                            property int yy: (index * 70 )+ 60;
                            Image {
                                id: bookmarklogo
                                source: "content/imgs/bookmark_"+ window.theme +".png"
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Image {
                                id: bookmarksourat
                                source: "content/imgs/index/"+ bookmarkelement.img +".png" //javascript avec conteur d index
                                anchors.right: bookmarklogo.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.rightMargin: 5
                            }
                            Text {
                                id: bookmarksouratlatin
                                text: bookmarkelement.name
                                font.pointSize: 7
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                anchors.verticalCenter: parent.verticalCenter//sourat
                                anchors.verticalCenterOffset: -10
                                color :"white"
                            }
                            Text {
                                id: bpage
                                text: "page: "+ (bookmarkelement.pge - 3);
                                color : window.color
                                anchors.top: bookmarksouratlatin.bottom
                                anchors.left:  parent.left
                                anchors.leftMargin: 20
                                font.pointSize: 4
                            }
                            MouseArea {
                                id : favmouse
                                anchors.fill: parent;
                                onClicked: {
                                    window.page = bookmarkelement.pge;
                                    window.source = "port.qml";
                                }
                                onPressAndHold: {
                                    MyJs.delatebookmark(bookmarkelement.pge,bookmarkelement.img,bookmarkelement.name);
                                    bpage.destroy();
                                    bookmarksouratlatin.destroy();
                                    bookmarksourat.destroy();
                                    bookmarklogo.destroy();
                                    bookmarkelement.width = 0;
                                }
                            }
                        }
                    }
                    // separation image
                    Image {
                        id: separation
                        source: "content/imgs/sep_"+ window.theme +".png"
                        anchors.right: bookmarkcolumn.right
                        anchors.rightMargin: 30
                    }
                }
            }

            //jouze listeview
            ListView{id: jouze
                width: 70;
                height: parent.height;
                y:0; x: parent.width - 70;
                model : JuzeModel {}
                header : Rectangle { width: jouze.width; height: 40; color:"transparent" }
                delegate: JuzeDelegate {}
                footer: Rectangle {width: parent.width; height: 50; color:"transparent"}
            }

            //tool bar
            Rectangle{
                id: header
                width:parent.width
                height: 60;
                anchors.top: parent.top;
                gradient: Gradient {
                         GradientStop { position: 0.25; color: "black" }
                         GradientStop { position: 1.0; color: "transparent" } //"transparent"
                }
                Image {
                    id: settingbtn
                    source: "content/imgs/setting.png"
                    x:0;y:0
                    opacity: sttingbtnmouse.pressed ? 0.3 :1;
                    MouseArea{
                        id:sttingbtnmouse
                        anchors.fill: parent;
                        onClicked: view.currentIndex = 1;
                    }
                }
                Image {
                    id: settingbook
                    source: "content/imgs/bmanager_" + window.theme +".png"
                    x:(mainliste.width/4);
                    y:0
                    opacity: settingbookmouse.pressed ? 0.3 :1;
                    MouseArea{
                        id: settingbookmouse
                        anchors.fill: parent;
                        onClicked: bookmangment.state == "bookoff" ? bookmangment.state = "bookon" : bookmangment.state = "bookoff";
                    }
                }
                Image {
                    id: lastpage
                    source: "content/imgs/page.png"
                    x:((mainliste.width*3)/4) - 50 ;
                    y:0
                    opacity: lastpagemouse.pressed ? 0.3 :1;
                    MouseArea{
                        id: lastpagemouse
                        anchors.fill: parent;
                        onClicked: { window.source = "port.qml";}
                    }
                }
                Image {
                    id: clsbtn
                    opacity: clsbtnmouse.pressed ? 0.3 :1;
                    source: "content/imgs/x.png";
                    anchors.right: parent.right;
                    anchors.rightMargin: 17
                    anchors.top:  parent.top;
                    MouseArea{
                        id: clsbtnmouse
                        anchors.fill: parent;
                        onClicked: {MyJs.closensave();}
                    }
                }
            }
            // fade bottom
            Rectangle{
                id: footer
                width:parent.width
                height: 60;
                anchors.bottom: parent.bottom;
                gradient: Gradient {
                         GradientStop { position: 1.0; color: "black" }
                         GradientStop { position: 0.0; color: "transparent" }
                }
            }


        }
        //setting image
        Rectangle {
            id: setting;
            color: "transparent";
            //source: "content/imgs/settingbg.png"
            width:mainliste.width
            height: mainliste.height
            //orientation
            Image {id: logo;
                source: "content/imgs/centerlogo_"+ window.theme +".png";
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.verticalCenter: parent.verticalCenter;
                z:2
                MouseArea{
                anchors.fill: parent;
                onClicked: Qt.openUrlExternally("http://www.zakilab.com/moushaf.html")
                }
            }

            Text {id: orientation
                text: "Screen Orientation"
                color: window.color
                anchors.top: setting.top
                anchors.left:  parent.left
                anchors.leftMargin: 12
                font.pointSize: 4
            }
            Row{id :orientationlock
                anchors.left : parent.left;
                anchors.leftMargin: 20
                spacing: 20
                anchors.topMargin: 10
                anchors.top : orientation.bottom;
                Image{
                    id : send;
                    source : "content/imgs/send.png"

                    //anchors.left : orientationlock.left
                    anchors.bottom: orientationlock.bottom
                    //anchors.topMargin: 20
                    anchors.leftMargin: 10
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: Qt.openUrlExternally("sms:?body=download Quran application for your phone from ZakiLab.com http://store.ovi.com/content/307275")
                    }
                }
                Image {
                    id: autorotation
                    source: master.viewlock === "all" ? "content/imgs/auto_"+ window.theme +".png" : "content/imgs/auto0.png";
                    MouseArea { anchors.fill: parent;
                        onClicked: {
                            MyJs.saveviewlock("all");
                    }
                    }
                }
                Image {
                    id: portre
                    source: master.viewlock === "port" ? "content/imgs/port_"+ window.theme +".png" : "content/imgs/port0.png";
                    MouseArea { anchors.fill: parent;
                        onClicked: {
                            MyJs.saveviewlock("port");
                    }
                    }
                }
                Image {
                    id: landscape
                    anchors.bottom: portre.bottom
                    source: master.viewlock === "land" ? "content/imgs/land_"+ window.theme +".png" : "content/imgs/land0.png";
                    MouseArea { anchors.fill: parent;
                        onClicked: {
                            MyJs.saveviewlock("land");
                    }
                    }
                }
            }

            Image {id: colorcha
                source: "content/imgs/colorburn.png"
                x :  (mainliste.width>mainliste.height) ? 550 :40;//
                y: (mainliste.width>mainliste.height) ? 320 :550;//
                transform: Rotation { origin.x: 0; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: (mainliste.width>mainliste.height) ? -90 : 0; }
                smooth: true
                //bleu : "#88e3ff" green : "#78da5d" pink : "#ea77a5" red : "#f17474" purp : "#be78f4"
                MouseArea{id :bleu
                    anchors.bottom: parent.bottom
                    anchors.left : parent.left;
                    height: parent.height;
                    width: 55;
                    hoverEnabled : true;
                    onClicked: { MyJs.savetheme("b","#88e3ff");}
                }
                MouseArea{id :green
                    anchors.left : bleu.right;
                    anchors.bottom: parent.bottom
                    height: parent.height;
                    width: 65;
                    hoverEnabled : true;
                    onClicked: { MyJs.savetheme("g","#78da5d")}
                }
                MouseArea{id :pink
                    anchors.left : green.right;
                    anchors.bottom: parent.bottom
                    height: parent.height;
                    width: 60;
                    hoverEnabled : true;
                    onClicked: {  MyJs.savetheme("p","#ea77a5");}
                }
                MouseArea{id :purp
                    anchors.left : pink.right;
                    anchors.bottom: parent.bottom
                    height: parent.height;
                    width: 36;
                    hoverEnabled : true;
                    onClicked: { MyJs.savetheme("pu","#be78f4");}
                }
                MouseArea{id :red
                    anchors.left : purp.right;
                    anchors.bottom: parent.bottom
                    height: parent.height;
                    width: 50;
                    hoverEnabled : true;
                    onClicked: { MyJs.savetheme("r","#f17474"); }
                }
            }
            Text {
                id: colortitel
                text: "Theme"
                color: window.color
                anchors.top : colorcha.top
                anchors.left: colorcha.left
                font.pointSize: 4
            }

        }


    }
    // listeview for 2 pages
    ListView {
        id: view
        anchors.rightMargin: 0;
        anchors.leftMargin: 0;
        anchors.topMargin: 0;
        anchors.fill: parent;
        anchors.centerIn: parent;
        model: itemModel
        preferredHighlightBegin: 0; preferredHighlightEnd: 0
        highlightRangeMode: ListView.StrictlyEnforceRange;
        highlightMoveDuration : 3000;
        highlightFollowsCurrentItem : true;
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem; flickDeceleration: 1000
        cacheBuffer: 200
    }


}
