import QtQuick.LocalStorage 2.0
import QtQuick 2.0
import "content/gestion.js" as MyJs

Rectangle {
    anchors.fill: parent
    id: main
    property int defaulty: MyJs.defaulty();
    Component.onCompleted: MyJs.flip();
    color: "#ffffff";
    /// seting btns
    Text {
        id: help
        text: "Saved to bookmarks"
        anchors.top: barup.top
        anchors.topMargin: 15
        color: "#ffffff"
        font.pointSize: 7*master.scale;
        anchors.left: bookmarkup.right;
        anchors.leftMargin: 20;
        opacity:0
        z:10
    }
    Timer{
        id:helptimer
        interval: 3000;
        onTriggered: help.opacity = 0
        running :help.opacity== 1 ? true:false;
        repeat: false;
    }
    Image {
        id: bookmarkup
        opacity: bookmarkupmouse.pressed ? 0.3 : 1;
        source: "content/imgs/book.png";
        height: (master.small/8);
        width: (master.small/8);
        anchors.left: barup.left;
        //anchors.leftMargin: 10
        //anchors.topMargin: 10
        anchors.top : barup.top;
        z:11
        MouseArea{
            id : bookmarkupmouse
            anchors.fill: parent;
            anchors.leftMargin: -10
            anchors.rightMargin: -10
            onClicked: {MyJs.addbookmark(); help.opacity= 1;} //console.log(window.bookmark)

        }

    }
    Image {
        id: listeup
        opacity: listeupmouse.pressed ? 0.3 : 1 ;
        source: "content/imgs/liste.png"
        anchors.right: barup.right;
        width: (master.small/8);
        height: (master.small/8);
        anchors.top : barup.top;
        z:11;
        MouseArea {
            //z:11;
            id:listeupmouse
            anchors.fill: parent;
            onClicked: window.source = "list.qml";
            /*onClicked: {
                menuwindow.z = 20;
                master.mouse = false;
            }*/
        }
    }
    // black fead bar;
    Rectangle{
        id: barup
        anchors.top: main.top;
        anchors.topMargin: -(main.height/6);
        width : main.width;
        height: main.height/6;
        x:0
        z:9

        gradient: Gradient {
                 GradientStop { position: 0.0; color: "#000000" }
                 GradientStop { position: 1.0; color:  "transparent"  }
             }
        states: [
            State {
                name :"upon"
                PropertyChanges { target: barup; anchors.topMargin: 0 }
            },
            State {
                name :"upoff"
                PropertyChanges { target: barup; anchors.topMargin: -(main.height/6) }
            }
        ]
        transitions :[
            Transition { to : "upon";
                        NumberAnimation { properties: "anchors.topMargin"; duration: 200 }
                    },
            Transition { to : "upoff";
                        NumberAnimation { properties: "anchors.topMargin"; duration: 200 }
                    }
        ]

    }

        Image{
        id : past;
        width: parent.width;
        onWidthChanged: { past.y = MyJs.defaulty(); present.y = MyJs.defaulty(); futur.y = MyJs.defaulty();}
        height: (sourceSize.height/sourceSize.width)* parent.width;
        x: 0;
        y: main.defaulty;
        source: "file:///sdcard/zakilab/moushaf/al-kabir/1.zlp";
        asynchronous: true;
        smooth : true;
        z : window.past_z;
        states: [
                 State {
                     name: "goDownPast"
                     PropertyChanges { target: past; x: main.width; y: main.defaulty }
                 },
                State {
                    name: "goDownPast0"
                    PropertyChanges { target: past; x: 0; y: main.defaulty }
                },
                State {
                    name: "goUpPast0"
                    PropertyChanges { target: past; x: main.width; y: main.defaulty }
                },
                State {
                    name: "goUpPast"
                    PropertyChanges { target: past; x: 0; y: main.defaulty }
                }
             ]
        transitions :[
            Transition { to : "goDownPast";
                        NumberAnimation { properties: "x,y"; duration: 200 }
                    },
            Transition { to : "goUpPast";
                        NumberAnimation { properties: "x,y"; duration: 200 }
                    }
        ]
    }
///////////////////////////////////////////////////////////////////////////////////////////////easing.type: Easing.OutBounce;
        Image{
        id : present; x:0;
        width: parent.width;
        y: main.defaulty;
        height: (sourceSize.height/sourceSize.width)* parent.width;
        source: "file:///sdcard/zakilab/moushaf/al-kabir/2.zlp";
        asynchronous: true;
        smooth : true;
        z:window.present_z;
        states: [
                 State {
                     name: "goDownPresent"
                     PropertyChanges { target: present; x: main.width; y: main.defaulty }
                 },
                State {
                    name: "goDownPresent0"
                    PropertyChanges { target: present; x: 0; y: main.defaulty }
                },
                State {
                    name: "goUpPresent0"
                    PropertyChanges { target: present; x: main.width; y: main.defaulty }
                },
                State {
                    name: "goUpPresent"
                    PropertyChanges { target: present; x: 0; y: main.defaulty }
                }
             ]
        transitions :[
            Transition { to : "goDownPresent";
                        NumberAnimation { properties: "x,y"; duration: 200 }
            },
            Transition { to : "goUpPresent";
                        NumberAnimation { properties: "x,y"; duration: 200 }
            }
        ]
    }
//////////////////////////////////////////////////////////////////////////////////////////////
        Image{
        id : futur;
        x:main.width;
        y: main.defaulty;
        width: parent.width;
        height: (sourceSize.height/sourceSize.width)* parent.width;
        source: "file:///sdcard/zakilab/moushaf/al-kabir/3.zlp";
        asynchronous: true;
        smooth : true;
        z:window.futur_z;
        //state:futur.state;
        states: [
                 State {
                     name: "goDownFutur"
                     PropertyChanges { target: futur; x: main.width; y: main.defaulty }
                 },
                State {
                    name: "goDownFutur0"
                    PropertyChanges { target: futur; x: 0; y: main.defaulty }
                },
                State {
                    name: "goUpFutur0"
                    PropertyChanges { target: futur; x: main.width; y: main.defaulty }
                },
                State {
                    name: "goUpFutur"
                    PropertyChanges { target: futur; x: 0; y: main.defaulty }
                }
             ]
        transitions :[
            Transition { to : "goDownFutur";
                        NumberAnimation { properties: "x,y"; duration: 200 }
            },
            Transition { to : "goUpFutur";
                        NumberAnimation { properties: "x,y"; duration: 200 }
            }
        ]
    }
////////////////////////////////////////////////////////////////////////////////////////////
    MouseArea {
        id: finger
        anchors.fill: parent
        //enabled : master.mouse == true ? true : false;
        z: 10
        property int oldx: 0;
        property int oldy: 0;
        property int varyx: 0;
        property int varyy: 0;
        property int dx: 0;
        property int dy: 0;
        property int tan: 0;
        onPressed: {
            var tmp = mapToItem(finger, mouseX, mouseY);
            oldx=tmp.x;
            oldy=tmp.y;
            varyx=tmp.x;
            varyy=tmp.y;
        }
        onPositionChanged: {
            var tmp2 = mapToItem(finger, mouseX, mouseY);
            var varyx2 = tmp2.x;
            var varyy2 = tmp2.y;
            dx = varyx2 - varyx;
            dy = varyy2 - varyy;
            varyx = varyx2;
            varyy = varyy2;
            MyJs.dragxy(dx,dy);
        }
        onReleased: {
            var tmp2 = mapToItem(finger, mouseX, mouseY);
            var deltax = tmp2.x - oldx;
            var deltay = tmp2.y - oldy;
            MyJs.release(deltax,deltay);
        }
///////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
    }
    /*
    FastBlur {
            id: blureffect;
            visible: master.mouse == true ? false : true;
            y: MyJs.blurey();
            x:0;
            width: parent.width;
            height : past.height;
            source : MyJs.blureffect();
            radius: 16;
            z:7;
    }
*/
    // black fead bar
    Rectangle{
        //////// add timer
        id: bardown
        anchors.bottom: main.bottom;
        anchors.bottomMargin: -(main.height/6);
        width : main.width;
        height: main.height/6;
        z:8
        gradient: Gradient {
                 GradientStop { position: 0.0; color: "transparent" }
                 GradientStop { position: 1.0; color: "#000000" }
             }
        states: [
            State {
                name :"downon"
                PropertyChanges { target: bardown; anchors.bottomMargin: 0}
            },
            State {
                name :"downoff"
                PropertyChanges { target: bardown; anchors.bottomMargin: -(main.height/6)}
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
        property int date;
        property int hours;
        property int minutes;
        property string hh : "";
        property string mm: "";
        function timeChanged() {
                 var date = new Date;
                 hours = date.getHours()
            if (hours<10) {hh = "0";} else { hh = ""}
                 minutes = date.getMinutes()
            if (minutes <10) {mm = "0"} else {mm = ""}
        }
        Timer {
            interval: 20000;
            running: bardown.state === "downon" ? true : false;
            repeat: true;
            onTriggered: bardown.timeChanged()
        }
        Text {
            id: timeindicator
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.leftMargin: 20;
        color : "#ffffff";
        text: " Time: "+ bardown.hh + bardown.hours + ":"+bardown.mm + bardown.minutes;
        font.pointSize: 7*master.scale;
        }
        Text {
        anchors.bottom: timeindicator.top;
        anchors.bottomMargin: 5
        anchors.left: parent.left;
        anchors.leftMargin: 20;
        color : "#ffffff";
        text: " Page: "+ (Math.abs(window.page - 3));
        font.pointSize: 7*master.scale;
        }
        Image {
            id: souratimg
            source: "content/imgs/index/" + window.currentsouratimg + ".png";
            height: sourceSize.height*master.scale;
            width: sourceSize.width*master.scale;
            anchors.right: parent.right;
            anchors.bottom: parent.bottom;
            asynchronous: true;
        }
    }

}


