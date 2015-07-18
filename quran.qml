import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import "content/gestion.js" as MyJs
Rectangle{
    id:master
    anchors.fill: parent;
    Component.onCompleted: MyJs.loadsetting();
    color : "#000000";
    property int small: MyJs.small();
    property int scale: master.small/360;
    property real ratio; //to change on start up
    property bool mouse: true;
    focus: true // important - otherwise we'll get no key events

        Keys.onReleased: {
            if (event.key === Qt.Key_Back) {
                //console.log("Back button captured - Alhamdou li Allah !")
                event.accepted = true;
                if(window.source == "qrc:///quran/pages.qml"){
                    MyJs.closensave();
                }else if(window.source == "qrc:///quran/settings.qml" && time.running == true ){
                    // time is note define !!!!!!
                    //window.dnum = posInfo.num -1;
                    //window.dmoushaf = posInfo.name;
                    //window.downloading = true;
                    //save
                    MyJs.alertthis("red","stop","all","","");
                }else{
                    window.source = "pages.qml";
                }
            }
        }
    Loader {
        id: window
        width : master.width;
        height : master.height;
        property int page: 5;
        property int list: 1
        property string lang;
        property string moushaf;

        property string dmoushaf: "al-kabir";
        property bool downloading: false;
        property int dnum: 1;

        property int bookmarknum;
        property string bookmark;

        property int prevsouratpage;
        property int nextsouratpage;

        property int currentsouratimg; // pour l'image
        property string currentsourat; //pour le text


        property string past_source: "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/"+ (window.page) + ".zlp";
        property int past_z: 3;

        property string present_source: "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/"+ (window.page+1) +".zlp";
        property int present_z: 2;

        property string futur_source: "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/" + (window.page-1)+".zlp";
        property int futur_z: 1;

        anchors.centerIn: parent;
        source: "splash.qml"
        z:3;
    }
    Rectangle{
        id: downloadmanager
        width:parent.width
        property string colorgard: "red"
        height: 60*master.scale;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: -downloadmanager.height;
        z:10;
        gradient: Gradient {
                 GradientStop { position: 1.0; color: downloadmanager.colorgard }
                 GradientStop { position: 0.0; color: "transparent" }
        }
        states: [
                    State {
                        name :"downon"
                        PropertyChanges { target: bardown; anchors.bottomMargin: 0}
                    },
                    State {
                        name :"downoff"
                        PropertyChanges { target: bardown; anchors.bottomMargin: -downloadmanager.height}
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
    }
}

