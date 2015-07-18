import QtQuick 2.0
import QtQuick.LocalStorage 2.0
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
        property int nerror: 0;
        property int num: 0;
        property int max : 624;
        property int charge : 0;
        property string state: "START"
        property string name : "al-kabir"
        property string image : posInfo.num + ".zlp";
        property string path: "/sdcard/zakilab/moushaf/" + posInfo.name + "/";
        property string prefix: "/";
        property string server: "http://www.zakilab.com/android/" + posInfo.name + posInfo.prefix + posInfo.image;
        anchors.fill: parent
        color: "#000000"
        opacity: 0.7
    }
    Timer {
            id: time
            interval: 200;
            running: false;
            repeat: true;
            onTriggered: {
                    if(posInfo.state == "FINISHED" || posInfo.state == "START"){ //si le telechargment de l'image est fini ou vient de démarrer la premiere image
                        posInfo.nerror = 0;
                        if(posInfo.num < posInfo.max){
                            posInfo.num = posInfo.num +1;
                            posInfo.image = posInfo.num + ".zlp";
                            posInfo.state = "new";
                            posInfo.charge = posInfo.num*parent.width*0.8/posInfo.max;

                            //MyJs.barfill(posInfo.name,posInfo.charge);
                            downloadbox.barcolor ="limegreen";
                            downloadbox.barwidth = posInfo.num*downloadbox.width/posInfo.max;
                            downloader.doDownload(posInfo.server, posInfo.image ,posInfo.path);
                        }else if(posInfo.num == posInfo.max && posInfo.state == "FINISHED"){ //si le telechargment a fini toutes les pages il telecharge le check.png
                            posInfo.num = posInfo.num +1;
                            posInfo.state = "new";

                            downloadbox.barcolor ="limegreen";
                            downloader.doDownload(posInfo.server, "check.zlp" ,posInfo.path);
                        }else if(posInfo.num > posInfo.max && posInfo.state == "FINISHED"){ // si le check.png est telecharger
                            time.running = false;
                            posInfo.state ="COMPLETE";
                            downloadbox.barcolor ="limegreen";
                            MyJs.setinfo(posInfo.name);
                            window.moushaf = posInfo.name;
                            MyJs.ratio(posInfo.name);
                            downloadbox.state = "downoff";
                        }
                    }else if(posInfo.state == "ERROR!" && posInfo.nerror >= 99){ //si il y a des erreurs
                        time.running = false;
                        //MyJs.barcolor(posInfo.name,"red");
                        //
                        downloadbox.barcolor = "red";
                        //error on downloading please check you internet Connections

                        posInfo.num = posInfo.num -1;
                        posInfo.image = posInfo.num + ".zlp";
                    }else if(posInfo.state == "ERROR!" && posInfo.nerror < 99){ //si le tele
                        downloadbox.barcolor = "orange";
                        posInfo.state = "FINISHED";
                        posInfo.nerror += 1;
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
                    onClicked: {window.moushaf = "al-kabir";MyJs.ratio("al-kabir");}
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
                    onClicked: MyJs.alertthis("red","manage","al-kabir","lime",0);
                }
                onStatusChanged: {if(dodownload1.status == Image.Error){dodownload1.source = "content/imgs/download.png"; select1.width = 0;}}
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
            Text {
                id: ms1
                text: "size : 71.11 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn1.bottom
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
            id:m8
            width: parent.width*0.9;
            anchors.bottomMargin: 20;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m1.width;
            source: "content/imgs/adi1-p.jpg"
            Rectangle{
                id: mr8
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar8
                height: parent.height*0.05;
                width: 0;
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select8
                source: window.moushaf == "aadi1" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr8.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: {window.moushaf = "aadi1";MyJs.ratio("aadi1");}
                }
            }
            Image {
                id: dodownload8
                source: "file:///sdcard/zakilab/moushaf/aadi1/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select8.left;
                anchors.top: mr8.top
                property string barcolor: "steelblue"
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.alertthis(dodownload8.barcolor,"manage","aadi1","lime",0);
                }
                onStatusChanged: {if(dodownload8.status == Image.Error){dodownload8.source = "content/imgs/download.png";dodownload8.barcolor="steelblue"; select8.width = 0;}else{dodownload8.barcolor="red"}}
            }
            Text {
                id: mn8
                text: "Aadi 1"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr8.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
            Text {
                id: ms8
                text: "size : 71.11 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn8.bottom
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
            id:m9
            width: parent.width*0.9;
            anchors.bottomMargin: 20;
            anchors.horizontalCenter: parent.horizontalCenter;
            height: (sourceSize.height/sourceSize.width)*m1.width;
            source: "content/imgs/adi2-p.jpg"
            Rectangle{
                id: mr9
                width: parent.width;
                height: parent.height*0.3;
                anchors.bottom: parent.bottom
                anchors.left: parent.left;
                color: "#000000";
                opacity: 0.6
            }
            Rectangle{
                id:bar9
                height: parent.height*0.05;
                width: 0;
                color: "lime"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }
            Image {
                id: select9
                source: window.moushaf == "aadi2" ? "content/imgs/select.png" : "content/imgs/unselect.png" ;
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: parent.right;
                anchors.top: mr9.top
                MouseArea{
                    anchors.fill: parent
                    onClicked: {window.moushaf = "aadi2";MyJs.ratio("aadi2");}
                }
            }
            Image {
                id: dodownload9
                source: "file:///sdcard/zakilab/moushaf/aadi2/check.zlp";
                height: parent.height*0.2;
                width: parent.height*0.2;
                anchors.right: select9.left;
                anchors.top: mr9.top
                MouseArea{
                    anchors.fill: parent;
                    onClicked: MyJs.managefiles("aadi2");
                }
                onStatusChanged: {if(dodownload9.status == Image.Error){dodownload9.source = "content/imgs/download.png"; select9.width = 0;}}
            }
            Text {
                id: mn9
                text: "Aadi 2"
                font.pointSize: Math.ceil(10*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mr9.top
                anchors.verticalCenter: parent.verticalCenter//sourat
                anchors.verticalCenterOffset: -10
                color :"white"
            }
            Text {
                id: ms9
                text: "size : 71.11 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn9.bottom
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
                    onClicked: {window.moushaf = "wasat";MyJs.ratio("wasat");}
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
                onStatusChanged: {if(dodownload2.status ==Image.Error){dodownload2.source = "content/imgs/download.png"; select2.width = 0;}}
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
            Text {
                id: ms2
                text: "size : 93.61 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn1.bottom
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
                    onClicked: {window.moushaf = "neskh";MyJs.ratio("neskh");}
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
                onStatusChanged: {if(dodownload3.status==Image.Error){dodownload3.source = "content/imgs/download.png"; select3.width = 0;}}
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
            Text {
                id: ms3
                text: "size : 71.11 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn1.bottom
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
                    onClicked: {window.moushaf = "kaloun";MyJs.ratio("kaloun");}
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
                onStatusChanged: {if(dodownload4.status==Image.Error){dodownload4.source = "content/imgs/download.png"; select4.width = 0;}}
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
            Text {
                id: ms4
                text: "size : 71.11 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn1.bottom
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
                    onClicked: {window.moushaf = "warch";MyJs.ratio("warch");}
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
                onStatusChanged: {if(dodownload5.status==Image.Error){dodownload5.source = "content/imgs/download.png"; select5.width = 0;}}
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
            Text {
                id: ms5
                text: "size : 163.55 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn1.bottom
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
                    onClicked: {window.moushaf = "chaabat";MyJs.ratio("chaabat");}
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
                onStatusChanged: {if(dodownload6.status==Image.Error){dodownload6.source = "content/imgs/download.png"; select6.width = 0;}}
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
            Text {
                id: ms6
                text: "size : 71.11 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn1.bottom
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
                    onClicked: {window.moushaf = "dawri";MyJs.ratio("dawri");}
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
                onStatusChanged: {if(dodownload7.status==Image.Error){dodownload7.source = "content/imgs/download.png"; select7.width = 0;}}
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
            Text {
                id: ms7
                text: "size : 71.11 MB"
                font.pointSize: Math.ceil(7*master.scale);
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: mn1.bottom
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
            id: helpbtn
            source: "content/imgs/help.png"
            x:0;y:0
            width: sourceSize.width*master.scale;
            height: sourceSize.height*master.scale;
            opacity: sttingbtnmouse.pressed ? 0.3 :1;
            MouseArea{
                id:sttingbtnmouse
                anchors.fill: parent;
                onClicked: window.source = "help.qml";
            }
        }
        Image {
            id: share
            source: "content/imgs/share.png"
            x:(master.width/2) - (25*master.scale) ;
            y:0
            width: sourceSize.width*master.scale;
            height: sourceSize.height*master.scale;
            opacity: lastpagemouse.pressed ? 0.3 :1;
            MouseArea{
                id: lastpagemouse
                anchors.fill: parent;
                onClicked: { window.source = "pages.qml";}
            }
        }
        Image {
            id: listebtn
            opacity: lisetmouse.pressed ? 0.3 :1;
            source: "content/imgs/liste.png";
            width: sourceSize.width*master.scale;
            height: sourceSize.height*master.scale;
            anchors.right: parent.right;
            anchors.rightMargin: 17
            anchors.top:  parent.top;
            MouseArea{
                id: lisetmouse
                anchors.fill: parent;
                onClicked: window.source = "list.qml";
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
                 GradientStop { position: 0.0; color: "transparent"}
        }
    }
    Rectangle{
        id: downloadbox
        z:10;
        width:parent.width
        property string colorgrad: "steelblue";

        property string action: "manage";
        property string what: "dawri";

        property string leftbtn: "yes";
        property string rightbtn: "no";

        property int barwidth: 0;
        property string barcolor: "lime";


        height: 100*master.scale;
        anchors.bottom: parent.bottom;
        state : "downoff";
        gradient: Gradient {
                 GradientStop { position: 1.0; color: downloadbox.colorgrad }
                 GradientStop { position: 0.2; color: downloadbox.colorgrad }
                 GradientStop { position: 0.0; color: "transparent"}
        }
        states: [
                    State {
                        name :"downon"
                        PropertyChanges { target: downloadbox; anchors.bottomMargin: 0}
                    },
                    State {
                        name :"downoff"
                        PropertyChanges { target: downloadbox; anchors.bottomMargin: -downloadbox.height}
                    }
                ]
                transitions :[
                    Transition { to : "downon";
                                NumberAnimation { properties: "anchors.bottomMargin"; duration: 200 }
                            },
                    Transition { to : "downoff";
                                NumberAnimation { properties: "anchors.bottomMargin"; duration: 200 }
                            }
                ]
        Image{
            id: startbtn;
            source : "content/imgs/unselect.png";
            anchors.right: parent.right;
            anchors.verticalCenter: parent.verticalCenter;
            width: parent.height*0.5;
            height: parent.height*0.5;
            MouseArea{
                anchors.fill: parent;
                onClicked: MyJs.confirm("right"); //download
            }
        }
        Image{
            id: stopbtn;
            source : "content/imgs/x.png";
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            width: parent.height*0.5;
            height: parent.height*0.5;
            MouseArea{
                anchors.fill: parent;
                onClicked:  MyJs.confirm("left"); //alert are you sure to stop
            }
        }
        Rectangle{
            id: progressbar
            height: parent.height*0.05;
            width: downloadbox.barwidth;
            color: downloadbox.barcolor;
            anchors.left: parent.left
            anchors.bottom: parent.bottom
        }

    }
    Rectangle{
        id: alertbox
        z:10;
        width:parent.width
        property string colorgrad: "red";

        property string action: "manage";
        property string what: "dawri";

        property string leftbtn: "yes";
        property string rightbtn: "no";

        property int barwidth: 0;
        property string barcolor: "lime";


        height: 100*master.scale;
        anchors.bottom: parent.bottom;
        state : "downoff";
        gradient: Gradient {
                 GradientStop { position: 1.0; color: alertbox.colorgrad }
                 GradientStop { position: 0.2; color: alertbox.colorgrad }
                 GradientStop { position: 0.0; color: "transparent"}
        }
        states: [
                    State {
                        name :"downon"
                        PropertyChanges { target: alertbox; anchors.bottomMargin: 0}
                    },
                    State {
                        name :"downoff"
                        PropertyChanges { target: alertbox; anchors.bottomMargin: -alertbox.height}
                    }
                ]
                transitions :[
                    Transition { to : "downon";
                                NumberAnimation { properties: "anchors.bottomMargin"; duration: 200 }
                            },
                    Transition { to : "downoff";
                                NumberAnimation { properties: "anchors.bottomMargin"; duration: 200 }
                            }
                ]
        Image{
            id: rightbtn;
            source : "content/imgs/unselect.png";
            anchors.right: parent.right;
            anchors.verticalCenter: parent.verticalCenter;
            width: parent.height*0.5;
            height: parent.height*0.5;
            MouseArea{
                anchors.fill: parent;
                onClicked: MyJs.confirm("right");
            }
        }
        Image{
            id: leftbtn;
            source : "content/imgs/x.png";
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            width: parent.height*0.5;
            height: parent.height*0.5;
            MouseArea{
                anchors.fill: parent;
                onClicked:  MyJs.confirm("left");
            }
        }

    }
}
