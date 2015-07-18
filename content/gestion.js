
var page;
var memorypage;
var current="past";
var precurrent;
//var db;// = LocalStorage.openDatabaseSync("MoushafQmlDB", "1.0", "Setting value for Moushaf DB", 10000);
function loadsetting() {
    var db = LocalStorage.openDatabaseSync("MoushafQmlDB", "1.0", "Setting value for Moushaf DB", 10000);
    db.transaction(
       function(tx) {
            // Create the database if it doesn't already exist
            tx.executeSql('CREATE TABLE IF NOT EXISTS MoushafSTG(setting TEXT, value TEXT)');
                    var rs = tx.executeSql('SELECT * FROM MoushafSTG WHERE setting = ?;',['database']);
                    var r = "";
                    for(var i = 0; i < rs.rows.length; i++) {
                        r += rs.rows.item(i).value;
                    }
                    if(r!='existe'){
                        tx.executeSql('INSERT INTO MoushafSTG VALUES(?, ?)', [ 'database', 'existe' ]);
                        tx.executeSql('INSERT INTO MoushafSTG VALUES(?, ?)', [ 'moushaf', 'al-kabir' ]);
                        tx.executeSql('INSERT INTO MoushafSTG VALUES(?, ?)', [ 'lastpage', '4' ]);
                        tx.executeSql('INSERT INTO MoushafSTG VALUES(?, ?)', [ 'currentsourat', 'Al fatiha' ]);
                        tx.executeSql('INSERT INTO MoushafSTG VALUES(?, ?)', [ 'bookmarksnum', '2' ]);
                        tx.executeSql('INSERT INTO MoushafSTG VALUES(?, ?)', [ 'bookmarks', '4,1,Al fatiha;5,2,Albakara;' ]);
                        tx.executeSql('INSERT INTO MoushafSTG VALUES(?, ?)', [ 'update', 'v1.0' ]);// importatnt

                        window.page = 4;
                        window.bookmarknum = 2;
                        window.moushaf = "al-kabir";
                        window.bookmark = "4,1,Al fatiha;5,2,Albakara;";
                        window.currentsourat = "Al fatiha";
                        window.prevsouratpage = -1;
                        window.nextsouratpage = 5;
                        window.source = "../pages.qml";

                        ratio("al-kabir");

                    } else {

                        // setting 1 moushaf
                        rs = tx.executeSql('SELECT * FROM MoushafSTG WHERE setting = ?;',['moushaf']);
                        var r1 = "";
                        for(var j1 = 0; j1 < rs.rows.length; j1++) {
                            r1 += rs.rows.item(j1).value;
                        }
                        window.moushaf = r1;
                        ratio(r1);

                        // setting 2 last page
                        rs = tx.executeSql('SELECT * FROM MoushafSTG WHERE setting = ?;',['lastpage']);
                        var r2 = "";
                        for(var j2 = 0; j2 < rs.rows.length; j2++) {
                            r2 += rs.rows.item(j2).value;
                        }
                        window.page = parseInt(r2);
                        //mapage(window.page);

                        // setting 3 bookmark number
                        rs = tx.executeSql('SELECT * FROM MoushafSTG WHERE setting = ?;',['bookmarksnum']);
                        var r3 = "";
                        for(var j3 = 0; j3 < rs.rows.length; j3++) {
                            r3 += rs.rows.item(j3).value;
                        }
                        window.bookmarknum = parseInt(r3);
                        console.log("bookmarknum")
                        console.log(r3)

                        // setting 4 bookmark liste
                        rs = tx.executeSql('SELECT * FROM MoushafSTG WHERE setting = ?;',['bookmarks']);
                        var r4 = "";
                        for(var j4 = 0; j4 < rs.rows.length; j4++) {
                            r4 += rs.rows.item(j4).value;
                        }
                        window.bookmark = r4;
                        console.log("bookmark")
                        console.log(r4)

                        // setting for update
                        window.source = "../pages.qml"
                    }
        }
    )
}

function defaulty(){
    var hd = master.height;
    var hmax = master.width * master.ratio;
    if(hmax < hd){
        return Math.floor(((hd-hmax)/2));
    }else{
        return 0;
    }
}
function small(){
    var w = master.width;
    var h = master.height;
    if(w<h){
        return w;
    }else{
        return h;
    }
}
function blureffect(){
    if(current == "past"){
         return past;
    }
    if(current == "present"){
        return present;
    }
    if(current == "futur"){
        return futur;
    }
}

function blurey(){
    if(current == "past"){
         return past.y;
    }
    if(current == "present"){
        return present.y;
    }
    if(current == "futur"){
        return futur.y;
    }
}

function listestartup(index,what){
    var bookmarks = window.bookmark.split(";");
    var block = bookmarks[index].split(",");
    if (what=== "page") return parseInt(block[0]);
    if (what === "img") return parseInt(block[1]);
    if (what === "en") return block[2];
}


function flip(){
    current = "past";
    page = window.page;
    mapage(page);
    past.z = window.past_z;
    present.z = window.present_z;
    futur.z = window.futur_z;
    past.source = window.past_source;
    present.source = window.present_source;
    futur.source = window.futur_source;

    var dy = defaulty();
    past.y = dy;
    present.y = dy;
    futur.y = dy;
}

function next() {
    if(current=="past") {
        past.state = "goDownPast";
        precurrent="present";
        past.z = 3;
        present.z = 2;
        futur.z = 1;
        futur.state = "goDownFutur0";
        page++; window.page = page;
        memorypage= page + 1;
        futur.source = "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/" + memorypage + ".zlp";
        mapage(page);
    }
    if(current=="present") {
        present.state = "goDownPresent";
        precurrent="futur";
        present.z = 3;
        futur.z = 2 ;
        past.z = 1;
        past.state ="goDownPast0";
        page++;window.page = page;
        memorypage= page + 1;
        past.source = "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/" + memorypage + ".zlp";
        mapage(page);
    }
    if(current=="futur") {
        futur.state = "goDownFutur";
        precurrent="past";
        futur.z = 3;
        past.z = 2;
        present.z = 1;
        present.state = "goDownPresent0";
        page++;window.page = page;
        memorypage= page + 1;
        present.source = "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/" + memorypage + ".zlp";
        mapage(page);
    }
    if(precurrent==="past"){current="past";}
    if(precurrent==="present"){current="present";}
    if(precurrent==="futur"){current="futur";}
}

function prev() {
    if(current=="past") {
        page--; window.page = page;
        memorypage= page - 1;
        present.source = "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/" + memorypage + ".zlp";
        futur.state = "goUpFutur";
        precurrent="futur";
        present.state = "goUpPresent0";
        present.z = 3;
        past.z = 1;
        futur.z = 2;
        mapage(page);
    }
    if(current=="present") {
        page--;window.page= page;
        memorypage= page - 1;
        futur.source = "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/" + memorypage + ".zlp";
        past.state = "goUpPast";
        precurrent="past";
        futur.state ="goUpFutur0";
        present.z = 1;
        futur.z = 3;
        past.z = 2;
        mapage(page);
    }
    if(current=="futur") {
        page--; window.page = page;
        memorypage= page - 1;
        past.source = "file:///sdcard/zakilab/moushaf/"+ window.moushaf +"/" + memorypage + ".zlp";
        present.state = "goUpPresent";
        precurrent="present";
        past.state = "goUpPast0";
        futur.z = 1;
        past.z = 3;
        present.z = 2;
        mapage(page);
    }
    if(precurrent==="past"){current="past";}
    if(precurrent==="present"){current="present";}
    if(precurrent==="futur"){current="futur";}
}

function dragxy(dx,dy){// try to make it smaler
    if (main.height>main.width){dragx(dx);}
    else {dragy(dy);}
}

function dragx(dx){
    //current = past;
    if(current== "past"){
        past.x += dx;
        if (past.x<0)past.x = 0;
        if (past.x>= (parent.width - 40)) past.x = parent.width - 40;
    }
    if(current== "present"){
        present.x += dx;
        if (present.x<0)present.x = 0;
        if (present.x>= (parent.width - 40)) present.x = parent.width - 40;
    }
    if(current== "futur"){
        futur.x += dx;
        if (futur.x<0)futur.x = 0;
        if (futur.x>= (parent.width - 40)) futur.x = parent.width - 40;
    }
}
function dragy(dy){
    //current = past;
    if(current== "past"){
        past.y += dy;
        if (past.y>0)past.y = 0;
        if (past.y<= (parent.height - past.height)) past.y = (parent.height - past.height);
    }
    if(current== "present"){
        present.y += dy;
        if (present.y>0)present.y = 0;
        if (present.y<= (parent.height - present.height)) present.y = (parent.height - past.height);
    }
    if(current== "futur"){
        futur.y += dy;
        if (futur.y>0)futur.y = 0;
        if (futur.y<= (parent.height - futur.height)) futur.y = (parent.height - futur.height);
    }
}
function release(deltax,deltay){
    var tan = Math.abs(deltay/deltax);
    if(deltax>20 && tan<1){
        next();
    } else if(deltax<-20 && tan<1 && page>1){
        prev();
    } else if(deltax<20 && deltax>-20 && deltay<20 && deltay>-20) {
        if(current==="past"){past.x = 0;showsettings();bardown.timeChanged()}
        if(current==="present"){present.x = 0;showsettings();bardown.timeChanged()}
        if(current==="futur"){futur.x = 0;showsettings();bardown.timeChanged()}
    } else if (window.height>window.width && tan>1){
        if(current==="past"){past.x = 0;}
        if(current==="present"){present.x = 0;}
        if(current==="futur"){futur.x = 0;} }
}
var alkabir = {
    pages: [4,5,53,80,109,131,154,180,190,211,224,238,252,258,265,270,285,296,308,315,325,335,345,353,362,370,380,388
        ,399,407,414,418,421,431,437,443,449,456,461,470,480,486,492,499,502,505,510,514,518,521,523,526,529,531,534,537,540
        ,545,548,552,554,556,557,559,561,563,565,567,569,571,573,575,577,578,580,581,583,585,586,588,589,590
        ,590,592,593,594,594,595,596,597,598,598,599,599,600,600,601,601,602,602,603,603,604,604,604,605,605,605,606,606,606,607,607,607,608],
    indexp :[4,5,53,80,109,131,154,180,190,211,224,238,252,258,265,270,285,296,308,315,325,335,345,353,362,370,380,388
        ,399,407,414,418,421,431,437,443,449,456,461,470,480,486,492,499,502,505,510,514,518,521,523,526,529,531,534,537,540
        ,545,548,552,554,556,557,559,561,563,565,567,569,571,573,575,577,578,580,581,583,585,586,588,589,590
        ,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608],
    liste:["Al-Fatihah","Al-Baqarah","`Ali `Imran","An-Nisa'","Al-Ma'idah","Al-'An`am","Al-'A`raf","Al-'Anfal","At-Tawbah","Yunus","Hud","Yusuf","Ar-Ra`d","Ibrahim","Al-Hijr","An-Nahl","Al-'Isra'","Al-Kahf","Maryam","Taha","Al-'Anbya'","Al-Haj","Al-Mu'minun","An-Nur","Al-Furqan","Ash-Shu`ara","An-Naml","Al-Qasas"
        ,"Al-`Ankabut","Ar-Rum","Luqman","As-Sajdah","Al-'Ahzab","Saba'","Fatir","Ya-Sin","As-Saffat","Sad","Az-Zumar","Ghafir","Fussilat","Ash-Shuraa","Az-Zukhruf","Ad-Dukhan","Al-Jathiyah","Al-'Ahqaf","Muhammad","Al-Fath","Al-Hujurat","Qaf","Adh-Dhariyat","At-Tur","An-Najm","Al-Qamar","Ar-Rahman","Al-Waqi`ah","Al-Hadid"
        ,"Al-Mujadila","Al-Hashr","Al-Mumtahanah","As-Saf","Al-Jumu`ah","Al-Munafiqun","At-Taghabun","At-Talaq","At-Tahrim","Al-Mulk","Al-Qalam","Al-Haqqah","Al-Ma`arij","Nuh","Al-Jinn","Al-Muzzammil","Al-Muddaththir","Al-Qiyamah","Al-'Insan","Al-Mursalat","An-Naba'","An-Nazi`at","Abasa","At-Takwir","Al-'Infitar"
        ,"Al-'Inshiqaq","Al-Buruj","At-Tariq","Al-Ghashiyah","Al-Fajr","Al-Balad","Ash-Shams","Ad-Duhaa","At-Tin","Al-Qadr","Az-Zalzalah","Al-Qari`ah","Al-`Asr","Quraysh","Al-Kafirun","Al-'Ikhlas","Al-'Ikhlas"],
    img: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,84,85,86,88,89,90,91,93,95,97,99,101,103,106,109,112,112]
};
var pages = alkabir.pages;

var indexpage=[4,5,53,80,109,131,154,180,190,211,224,238,252,258,265,270,285,296,308,315,325,335,345,353,362,370,380,388
        ,399,407,414,418,421,431,437,443,449,456,461,470,480,486,492,499,502,505,510,514,518,521,523,526,529,531,534,537,540
        ,545,548,552,554,556,557,559,561,563,565,567,569,571,573,575,577,578,580,581,583,585,586,588,589,590
        ,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608];

var liste=["Al-Fatihah","Al-Baqarah","`Ali `Imran","An-Nisa'","Al-Ma'idah","Al-'An`am","Al-'A`raf","Al-'Anfal","At-Tawbah","Yunus","Hud","Yusuf","Ar-Ra`d","Ibrahim","Al-Hijr","An-Nahl","Al-'Isra'","Al-Kahf","Maryam","Taha","Al-'Anbya'","Al-Haj","Al-Mu'minun","An-Nur","Al-Furqan","Ash-Shu`ara","An-Naml","Al-Qasas"
        ,"Al-`Ankabut","Ar-Rum","Luqman","As-Sajdah","Al-'Ahzab","Saba'","Fatir","Ya-Sin","As-Saffat","Sad","Az-Zumar","Ghafir","Fussilat","Ash-Shuraa","Az-Zukhruf","Ad-Dukhan","Al-Jathiyah","Al-'Ahqaf","Muhammad","Al-Fath","Al-Hujurat","Qaf","Adh-Dhariyat","At-Tur","An-Najm","Al-Qamar","Ar-Rahman","Al-Waqi`ah","Al-Hadid"
        ,"Al-Mujadila","Al-Hashr","Al-Mumtahanah","As-Saf","Al-Jumu`ah","Al-Munafiqun","At-Taghabun","At-Talaq","At-Tahrim","Al-Mulk","Al-Qalam","Al-Haqqah","Al-Ma`arij","Nuh","Al-Jinn","Al-Muzzammil","Al-Muddaththir","Al-Qiyamah","Al-'Insan","Al-Mursalat","An-Naba'","An-Nazi`at","Abasa","At-Takwir","Al-'Infitar"
        ,"Al-'Inshiqaq","Al-Buruj","At-Tariq","Al-Ghashiyah","Al-Fajr","Al-Balad","Ash-Shams","Ad-Duhaa","At-Tin","Al-Qadr","Az-Zalzalah","Al-Qari`ah","Al-`Asr","Quraysh","Al-Kafirun","Al-'Ikhlas","Al-'Ikhlas"];
var img=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,84,85,86,88,89,90,91,93,95,97,99,101,103,106,109,112,112]

function mapage(thepage){
    var p;
    if(thepage <545){
        if(thepage <399){
            for(p=0;p<28;p++){
                if(indexpage[p]<= thepage && thepage <indexpage[p+1]){
                    window.currentsouratimg = img[p];
                    window.currentsourat = liste[p];
                }
            }
        }else{
            for(p=28;p<56;p++){
                if(indexpage[p]<=thepage && thepage <indexpage[(p+1)]){
                    window.currentsouratimg = img[p];
                    window.currentsourat = liste[p];
                }
            }
        }
    } else{
        if(thepage <592){
            for(p=56;p<80;p++){
                if(indexpage[p]<=thepage && thepage <indexpage[(p+1)]){
                    window.currentsouratimg = img[p];
                    window.currentsourat = liste[p];
                }
            }
        }else{
            for(p=80;p<98;p++){
                if(indexpage[p]<=thepage && thepage <indexpage[(p+1)]){
                    window.currentsouratimg = img[p];
                    window.currentsourat = liste[p];
                }
            }
        }
    }

}

function addbookmark(){
    var newbookmark = window.page + "," + window.currentsouratimg + "," + window.currentsourat + ";";
window.bookmark += newbookmark;
    var splitbookmark = window.bookmark.split(";");
window.bookmarknum = splitbookmark.length-1;
    //console.log("new bookmark" + newbookmark)
    //console.log(window.bookmark)
    //console.log(window.bookmarknum)
    var db = LocalStorage.openDatabaseSync("MoushafQmlDB", "1.0", "Setting value for Moushaf DB", 10000);
    db.transaction(
       function(addingbookmark) {
            addingbookmark.executeSql('UPDATE MoushafSTG SET value=? WHERE setting=?;', [ window.bookmark, "bookmarks" ]);
            addingbookmark.executeSql('UPDATE MoushafSTG SET value=? WHERE setting=?;', [ window.bookmarknum, "bookmarksnum" ]);
       }
    )
}

function delatebookmark(bookpage,bookimg,bookname){
    var booktodelate = bookpage + "," + bookimg + "," + bookname + ";";                                         //console.log("book mark to del : "+booktodelate); ///// debug
    var bookmarksep = window.bookmark.split(booktodelate);
    var newbookmark = "";
    for(var i=0; i<bookmarksep.length; i++){
        newbookmark +=bookmarksep[i];
    }
    var splitbookmark2 = newbookmark.split(";");
    var newbnum = splitbookmark2.length -1;
    window.bookmarknum = newbnum;
    window.bookmark = newbookmark;
    var db = LocalStorage.openDatabaseSync("MoushafQmlDB", "1.0", "Setting value for Moushaf DB", 10000);
    db.transaction(
       function(delbookmark) {
            delbookmark.executeSql('UPDATE MoushafSTG SET value=? WHERE setting=?;', [ newbookmark, "bookmarks" ]);
            delbookmark.executeSql('UPDATE MoushafSTG SET value=? WHERE setting=?;', [ newbnum, "bookmarksnum" ]);
       }
    )
}

function showsettings(){
    barup.state = barup.state === "upon" ? "upoff" : "upon";
    bardown.state = bardown.state ==="downon" ? "downoff":"downon";
}

function closensave(){
        var db = LocalStorage.openDatabaseSync("MoushafQmlDB", "1.0", "Setting value for Moushaf DB", 10000);
        db.transaction(
           function(savingtheme) {
                savingtheme.executeSql('UPDATE MoushafSTG SET value=? WHERE setting=?;', [ window.moushaf, "moushaf" ]);
                savingtheme.executeSql('UPDATE MoushafSTG SET value=? WHERE setting=?;', [ window.page, "lastpage" ]);
                //savingtheme.executeSql('UPDATE MoushafSTG SET value=? WHERE setting=?;', [ window.bookmark, "bookmarks" ]);
                //savingtheme.executeSql('UPDATE MoushafSTG SET value=? WHERE setting=?;', [ window.bookmarknum, "bookmarksnum" ]);
           }
        )
    Qt.quit();
}


function checkfiles(){
   if(dodownload1.statu == Image.Error){dodownload1.source = "content/imgs/download.png";}
   if(dodownload2.statu == Image.Error){dodownload2.source = "content/imgs/download.png";}
   if(dodownload3.statu == Image.Error){dodownload3.source = "content/imgs/download.png";}
   if(dodownload4.statu == Image.Error){dodownload4.source = "content/imgs/download.png";}
   if(dodownload5.statu == Image.Error){dodownload5.source = "content/imgs/download.png";}
   if(dodownload6.statu == Image.Error){dodownload6.source = "content/imgs/download.png";}
   if(dodownload7.statu == Image.Error){dodownload7.source = "content/imgs/download.png";}
}


function ratio(name){
    switch (name) {
    case "al-kabir":
        master.ratio = 1.56812;
        break;
    case "wasat":
        master.ratio = 1.46623;
        break;
    case "neskh":
        master.ratio = 1.54963;
        break;
    case "kaloun":
        master.ratio = 1.470454;
        break;
    case "warch":
        master.ratio = 1.47152;
        break;
    case "chaabat":
        master.ratio = 1.51044;
        break;
    case "dawri":
        master.ratio = 1.51401;
        break;
    case "aadi1":
        master.ratio = 1.51168;
        break;
    case "aadi2":
        master.ratio = 1.52705;
        break;
    }

}
//to remouve no longer supported
function barfill(name,percent){
    switch (name) {
    case "al-kabir":
        bar1.width = percent;
        break;
    case "wasat":
        bar2.width = percent;
        break;
    case "neskh":
        bar3.width = percent;
        break;
    case "kaloun":
        bar4.width = percent;
        break;
    case "warch":
        bar5.width = percent;
        break;
    case "chaabat":
        bar6.width = percent;
        break;
    case "dawri":
        bar7.width = percent;
        break;
    }
}
function barcolor(name,color){
    switch (name) {
    case "al-kabir":
        bar1.color = color;
        break;
    case "wasat":
        bar2.color = color;
        break;
    case "neskh":
        bar3.color = color;
        break;
    case "kaloun":
        bar4.color = color;
        break;
    case "warch":
        bar5.color = color;
        break;
    case "chaabat":
        bar6.color = color;
        break;
    case "dawri":
        bar7.color = color;
        break;
    }
}


function setinfo(name){
    switch (name) {
    case "al-kabir":
        dodownload1.source = "file:///sdcard/zakilab/moushaf/al-kabir/check.zlp";
        select1.width = select1.height;
        break;
    case "wasat":
        dodownload2.source = "file:///sdcard/zakilab/moushaf/wasat/check.zlp";
        select2.width = select2.height;
        break;
    case "neskh":
        dodownload3.source = "file:///sdcard/zakilab/moushaf/neskh/check.zlp";
        select3.width = select3.height;
        break;
    case "kaloun":
        dodownload4.source = "file:///sdcard/zakilab/moushaf/kaloun/check.zlp";
        select4.width = select4.height;
        break;
    case "warch":
        dodownload5.source = "file:///sdcard/zakilab/moushaf/warch/check.zlp";
        select5.width = select5.height;
        break;
    case "chaabat":
        dodownload6.source = "file:///sdcard/zakilab/moushaf/chaabat/check.zlp";
        select6.width = select6.height;
        break;
    case "dawri":
        dodownload7.source = "file:///sdcard/zakilab/moushaf/dawri/check.zlp";
        select7.width = select7.height;
        break;
    }
}

function managefiles(thename){
    if(time.running == false){
        switch (thename) {
            //change the icons left n right
            //change the action
            case "al-kabir":
                console.log("the source : " + dodownload1.source)
                if(dodownload1.source == "qrc:///quran/content/imgs/download.png"){
                    //set values
                    posInfo.name = thename;
                    posInfo.max = 624;
                    posInfo.prefix = "/page";
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/al-kabir/");
                    dodownload1.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                    //do not forget to reset the valus
                }
                break;
            case "aadi1":
                console.log("the source : " + dodownload1.source)
                if(dodownload8.source == "qrc:///quran/content/imgs/download.png"){
                    //set values
                    posInfo.name = thename;
                    posInfo.max = 624;
                    posInfo.prefix = "/";
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/aadi1/");
                    dodownload8.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                    //do not forget to reset the valus
                }
                break;
            case "aadi2":
                //console.log("the source : " + dodownload9.source)
                if(dodownload9.source == "qrc:///quran/content/imgs/download.png"){
                    //set values
                    posInfo.name = thename;
                    posInfo.max = 624;
                    posInfo.prefix = "/";
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/aadi2/");
                    dodownload9.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                    //do not forget to reset the valus
                }
                break;
            case "wasat":
                //console.log("the source : " + dodownload1.source)
                if(dodownload2.source == "qrc:///quran/content/imgs/download.png"){
                    posInfo.name = thename;
                    posInfo.max = 624;
                    posInfo.prefix = "/";
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/wasat/");
                    dodownload2.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                }
                break;
            case "neskh":
                if(dodownload3.source == "qrc:///quran/content/imgs/download.png"){
                    posInfo.name = thename;
                    posInfo.max = 620;
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;
                    posInfo.prefix = "/";

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/neskh/");
                    dodownload3.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                }
                break;
            case "kaloun":
                if(dodownload4.source == "qrc:///quran/content/imgs/download.png"){
                    posInfo.name = thename;
                    posInfo.max = 576;
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;
                    posInfo.prefix = "/";

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/kaloun/");
                    dodownload4.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                }
                break;
            case "warch":
                if(dodownload5.source == "qrc:///quran/content/imgs/download.png"){
                    posInfo.name = thename;
                    posInfo.max = 576;
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;
                    posInfo.prefix = "/";

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/warch/");
                    dodownload5.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                }
                break;
            case "chaabat":
                if(dodownload6.source == "qrc:///quran/content/imgs/download.png"){
                    posInfo.name = thename;
                    posInfo.max = 624;
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;
                    posInfo.prefix = "/";

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/chaabat/");
                    dodownload6.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                }
                break;
            case "dawri":
                if(dodownload7.source == "qrc:///quran/content/imgs/download.png"){
                    posInfo.name = thename;
                    posInfo.max = 544;
                    posInfo.state = "START";
                    posInfo.charge = 0;
                    posInfo.num = 0;
                    posInfo.prefix = "/";

                    time.running = true;
                }else{
                    downloader.remFolder("/sdcard/zakilab/moushaf/dawri/");
                    dodownload7.source = "content/imgs/download.png";
                    alertbox.state = "downoff";
                }
                break;
        }
    }
}
function alertthis(c,fx,x){

    alertbox.colorgrad = c;
    alertbox.action = fx;
    alertbox.what = x;
    alertbox.state = "downon";
}

function confirm(answer){
    if(answer=="left"){
        alertbox.state = "downoff";
    }else{
        if(alertbox.action == "manage"){
            alertbox.state = "downoff";
            downloadbox.state = "downon"; //show the download bar
            managefiles(alertbox.what); //start the download
        }else if(alertbox.action == "abort"){
            //stop the download

            alertbox.state = "downoff"; //hide the alert and the download
            downloadbox.state = "downoff";
        }
    }
}
