import QtQuick 2.0
import "content/gestion.js" as MyJs
import QtGraphicalEffects 1.0

Rectangle {
    id:big
    anchors.fill: parent
    color :"#FFFFFF";
    //background
    Image{
        id : backlist;
        width: parent.width;
        onWidthChanged: { backlist.y = MyJs.defaulty();}
        height: (sourceSize.height/sourceSize.width)* parent.width;
        x: 0;
        y: main.defaulty;
        source: "file:///sdcard/zakilab/moushaf/" + window.moushaf + "/" + window.page + ".zlp";
        asynchronous: true;
        smooth : true;
    }
    GaussianBlur {
            anchors.fill: backlist
            source: backlist
            radius: 16
            samples: 32
        }
    Rectangle{
        id: posInfo
        property int num: 0;
        property int max : 624;
        property int charge : 0;
        property string state: "START"
        property string name : "al-kabir"
        property string image : posInfo.num + ".zlp";
        property string path: "/sdcard/zakilab/moushaf/" + posInfo.name + "/";
        property string server: "http://www.zakilab.com/android/" + posInfo.name + "/page" + posInfo.image;
        anchors.fill: parent
        color: "#000000"
        opacity: 0.7
    }
    Timer {
            id: time
            interval: 250;
            running: false;
            repeat: true;
            onTriggered: {
                    if(posInfo.state == "FINISHED" || posInfo.state == "START"){
                        if(posInfo.num < posInfo.max){
                            posInfo.num = posInfo.num +1;
                            posInfo.image = posInfo.num + ".zlp";
                            posInfo.state = "new";
                            posInfo.charge = posInfo.num*parent.width/posInfo.max;
                            MyJs.barfill(posInfo.name,posInfo.charge);
                            downloader.doDownload(posInfo.server, posInfo.image ,posInfo.path);
                        }else if(posInfo.num == posInfo.max && posInfo.state == "FINISHED"){
                            posInfo.num = posInfo.num +1;
                            downloader.doDownload(posInfo.server, "check.zlp" ,posInfo.path);
                        }else{
                            time.running = false;
                            posInfo.state ="COMPLETE";
                            MyJs.barfill(posInfo.name,parent.width);
                            MyJs.barcolor(posInfo.name,"limegreen");
                            window.moushaf = posInfo.name;
                        }
                    }else if(posInfo.state == "ERROR!"){
                        time.running = false;
                        MyJs.barcolor(posInfo.name,"red");
                        //error on downloading please check you internet Connections

                        //reset the download
                        posInfo.num = posInfo.num -1;
                        posInfo.image = posInfo.num + ".zlp";
                    }
                    posInfo.state = downloader.doStat();
            }
        }

    //////////////////////////////////////////////////////
    //Component.onCompleted: MyJs.checkfiles();
    VisualItemModel{
        id: itemModel
        Rectangle{
            width:parent.width
            height: 60*master.scale;
            color: "transparent";
        }
        Rectangle{
            width: parent.width;
            height: master.small*0.8;
            color: "transparent"
            Image{
                id : logotop
                width: master.small*0.8;
                height: master.small*0.8;
                anchors.topMargin: 60*master.scale;
                //anchors.bottomMargin: master.small*0.1;
                anchors.horizontalCenter: parent.horizontalCenter;
                source: "content/imgs/quran.png";
                smooth : true;
                MouseArea{
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("http://www.ZakiLab.com/android")
                }
            }
        }
        Column {
            id:bookmarkcolumn
            Rectangle{
                id:videupindex
                width: big.width
                height: 10
                color:"transparent"
                //anchors.top : mainliste.top;
            }
            Repeater{
                id:bookmarkrepeater
                model: window.bookmarknum//mainliste.times;//2//window.bookmarknum;
                // Al hamdou li Allah
                Rectangle{
                    id:bookmarkelement
                    width: big.width*0.9
                    anchors.horizontalCenter: videupindex.horizontalCenter
                    height: 70*master.scale; ///a changer dinamiquement
                    color: "transparent"
                    property int img : MyJs.listestartup(index,"img")
                    property string name : MyJs.listestartup(index,"en")
                    property int pge : MyJs.listestartup(index,"page");
                    property int yy: (index * 70 * master.scale )+ (60*master.scale);
                    Image {
                        id: bookmarklogo
                        source: "content/imgs/delbook.png"
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
                        anchors.fill: bookmarklogo;
                        onClicked: {
                            MyJs.delatebookmark(bookmarkelement.pge,bookmarkelement.img,bookmarkelement.name);
                            bpage.destroy();
                            bookmarksouratlatin.destroy();
                            bookmarksourat.destroy();
                            bookmarklogo.destroy();
                            bookmarkelement.height = 0;
                        }
                    }
                }
            }
        }
        Image {
            id:m1
            width: parent.width*0.9;
            anchors.bottomMargin: 20;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m1.width;
            source: "content/imgs/al-kabir.jpg"
            Rectangle{
                id: mr1
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar1
                height: parent.height*0.05;
                width: 0;
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select1
                source: window.moushaf == "al-kabir" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr1.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: window.moushaf = "al-kabir";
                }
            }
            Image {
                id: dodownload1
                source: "file:///sdcard/zakilab/moushaf/al-kabir/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select1.left;
                anchors.top: mr1.top
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.managefiles("al-kabir");
                }
                onStatusChanged: {if(dodownload1.status == Image.Error){dodownload1.source = "content/imgs/download.png"; console.log(dodownload1.source)}}
            }
            Text {
                id: mn1
                text: "Al-Kabir"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr1.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
        }
        Rectangle{
            height: master.small*0.1;
            width: parent.width;
            color: "transparent"
        }
        ////////////////////////////////////////////////////////////////
        Image {
            id:m2
            width: parent.width*0.9;
            anchors.bottomMargin: master.small*0.1;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m2.width;
            source: "content/imgs/wasat.jpg"
            Rectangle{
                id: mr2
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar2
                height: parent.height*0.05;
                width: 0
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select2
                source: window.moushaf == "wasat" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr2.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: window.moushaf = "wasat";
                }
            }
            Image {
                id: dodownload2
                source: "file:///sdcard/zakilab/moushaf/wasat/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select2.left;
                anchors.top: mr2.top
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.managefiles("wasat");
                }
                onStatusChanged: {if(dodownload2.status ==Image.Error){dodownload2.source = "content/imgs/download.png";}}
            }
            Text {
                id: mn2
                text: "Wasat"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr2.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
        }
        Rectangle{
            width:parent.width
            height: 60*master.scale;
            color: "transparent";
        }
        ////////////////////////////////////////////////////////////////
        Image {
            id:m3
            width: parent.width*0.9;
            anchors.bottomMargin: 20;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m3.width;
            source: "content/imgs/neskh-p.jpg"
            Rectangle{
                id: mr3
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar3
                height: parent.height*0.05;
                width: 0
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select3
                source: window.moushaf == "neskh" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr3.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: window.moushaf = "neskh";
                }

            }
            Image {
                id: dodownload3
                source: "file:///sdcard/zakilab/moushaf/neskh/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select3.left;
                anchors.top: mr3.top
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.managefiles("neskh");
                }
                onStatusChanged: {if(dodownload3.status==Image.Error){dodownload3.source = "content/imgs/download.png";}}
            }
            Text {
                id: mn3
                text: "Neskh Taalik"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr3.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
        }
        Rectangle{
            height: master.small*0.1;
            width: parent.width;
            color: "transparent"
        }
        /////////////////////////////////////////////////////////
        Image {
            id:m4
            width: parent.width*0.9;
            anchors.bottomMargin: 20;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m4.width;
            source: "content/imgs/kaloun-p.jpg"
            Rectangle{
                id: mr4
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar4
                height: parent.height*0.05;
                width: 0
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select4
                source: window.moushaf == "kaloun" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr4.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: window.moushaf = "kaloun";
                }

            }
            Image {
                id: dodownload4
                source: "file:///sdcard/zakilab/moushaf/kaloun/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select4.left;
                anchors.top: mr4.top
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.managefiles("kaloun");
                }
                onStatusChanged: {if(dodownload4.status==Image.Error){dodownload4.source = "content/imgs/download.png";}}
            }
            Text {
                id: mn4
                text: "Kaloun"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr4.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
        }
        Rectangle{
            height: master.small*0.1;
            width: parent.width;
            color: "transparent"
        }
        //////////////////////////////////////////////////////////////
        Image {
            id:m5
            width: parent.width*0.9;
            anchors.bottomMargin: 20;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m5.width;
            source: "content/imgs/warch-p.jpg"
            Rectangle{
                id: mr5
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar5
                height: parent.height*0.05;
                width: 0
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select5
                source: window.moushaf == "warch" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr5.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: window.moushaf = "warch";
                }

            }
            Image {
                id: dodownload5
                source: "file:///sdcard/zakilab/moushaf/warch/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select5.left;
                anchors.top: mr5.top
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.managefiles("warch");
                }
                onStatusChanged: {if(dodownload5.status==Image.Error){dodownload5.source = "content/imgs/download.png";}}
            }
            Text {
                id: mn5
                text: "Warch"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr5.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
        }
        Rectangle{
            height: master.small*0.1;
            width: parent.width;
            color: "transparent"
        }
        ///////////////////////////////////////////////////////////////////
        Image {
            id:m6
            width: parent.width*0.9;
            anchors.bottomMargin: 20;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m6.width;
            source : "content/imgs/chaabat-p.jpg"
            Rectangle{
                id: mr6
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar6
                height: parent.height*0.05;
                width: 0
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select6
                source: window.moushaf == "chaabat" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr6.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: window.moushaf = "chaabat";
                }

            }
            Image {
                id: dodownload6
                source: "file:///sdcard/zakilab/moushaf/chaabat/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select6.left;
                anchors.top: mr6.top
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.managefiles("chaabat");
                }
                onStatusChanged: {if(dodownload6.status==Image.Error){dodownload6.source = "content/imgs/download.png";}}
            }
            Text {
                id: mn6
                text: "Chaabat"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr6.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
        }
        Rectangle{
            height: master.small*0.1;
            width: parent.width;
            color: "transparent"
        }
        Image {
            id:m7
            width: parent.width*0.9;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m7.width;
            source: "content/imgs/dawri-p.jpg"
            Rectangle{
                id: mr7
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar7
                height: parent.height*0.05;
                width: 0
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select7
                source: window.moushaf == "dawri" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr7.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: window.moushaf = "dawri";
                }

            }
            Image {
                id: dodownload7
                source: "file:///sdcard/zakilab/moushaf/dawri/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select7.left;
                anchors.top: mr7.top
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.managefiles("dawri");
                }
                onStatusChanged: {if(dodownload7.status==Image.Error){dodownload7.source = "content/imgs/download.png";}}
            }
            Text {
                id: mn7
                text: "Dawri"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr7.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
        }
        Rectangle{
            height: master.small*0.1;
            width: parent.width;
            color: "transparent"
        }


    }
    ListView {
        id: view
        anchors.fill : parent;
        model: itemModel
        flickDeceleration: 1000
        cacheBuffer: 200
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
            source: "content/imgs/liste.png"
            x:0;y:0
            width: sourceSize.width*master.scale;
            height: sourceSize.height*master.scale;
            opacity: sttingbtnmouse.pressed ? 0.3 :1;
            MouseArea{
                id:sttingbtnmouse
                anchors.fill: parent;
                onClicked: window.source = "list.qml";
            }
        }
        Image {
            id: lastpage
            source: "content/imgs/page.png"
            x:((master.width*3)/4) - (50*master.scale) ;
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
        }
        Image {
            id: clsbtn
            opacity: clsbtnmouse.pressed ? 0.3 :1;
            source: "content/imgs/x.png";
            width: sourceSize.width*master.scale;
            height: sourceSize.height*master.scale;
            anchors.right: parent.right;
            anchors.rightMargin: 17
            anchors.top:  parent.top;
            MouseArea{
                id: clsbtnmouse
                anchors.fill: parent;
                onClicked: {
                    Qt.quit();
                    //MyJs.closensave();
                }
            }
        }
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
