import QtQuick 2.2
import OSC 1.0

/**************************************************************
 OSC SOCKET
 **************************************************************/
Item {
    id: root
    property string host: "localhost"
    property real sendPort: 3334;
    property real receivePort: 3333;
    property string address: "";
    property  real seekValue: -1;

    /**************************************************************
     OSC SEND
     **************************************************************/
    OSCSender {
        id: oscSend
        ip: host
        port: sendPort
    }

    /**************************************************************
     OSC RECEIVE
     **************************************************************/
    OSCReceiver {
        id: oscReceive
        port: receivePort
        property real duration: 0;

        onMessage: {
            if (address == "/input/position") {

                if (controlPanel.cType == "video") {
                    if (msg == "-inf"){
                        return
                    }
                   if (Number.fromLocaleString(msg) === null)
                        controlPanel.positionValue = 0;
                   else
                       controlPanel.positionValue = Number.fromLocaleString (msg);

                    controlPanel.time = secondsToHms(controlPanel.cDuration* Number.fromLocaleString (msg));

                   if (controlPanel.positionValue*controlPanel.duration >= controlPanel.duration){
                        playlistPanel.next();
                   }
                }
            }
            else if (address == "/input/duration") {
                var file = msg.split(",")[0];
                var dur = parseFloat(msg.split(",")[1]);
                controlPanel.cDuration = parseFloat(dur);

                db.updateLibraryItemDuration(file, dur)
                libraryPanel.loadSort();

                var c;
                for (var i=0; i<playlistPanel.getCount(); i++){
                    c = playlistPanel.getFileByIndex(i);

                    if (c === plist.convertToNativePath(file)){
                        playlistPanel.setProperty(i, "duration", dur);
                        playlistPanel.sumPlaylistDuration();
                    }
                }
            }
            else if (address == "/input/" && msg == "end")  {
                controlPanel.end();
            }
        }
    }

    /**************************************************************
     SEND
     **************************************************************/
    function send(address, msg){
       oscSend.send(address, msg);
    }

    /**************************************************************
     SEND SOURCE
     **************************************************************/
    function sendSource(value){
       send("/input/source/", value);
    }

    /**************************************************************
     SEND FILE
     **************************************************************/
    function sendFile(filepath){
        send("/input/file/", filepath);
    }

    /**************************************************************
     SEND PLAY
     **************************************************************/
    function sendPlay(){
        send("/input/", "play");
    }

    /**************************************************************
     SEND PAUSE
     **************************************************************/
    function sendPause(){
       send("/input/", "stop");
    }

    /**************************************************************
     SEND SEEK
     **************************************************************/
    function sendSeek(pos){
       seekValue = pos;
       send("/input/seek/", pos);
    }

    /**************************************************************
     SEND VOLUME
     **************************************************************/
    function sendVolume(vol){
       send("/input/volume/", vol);
    }

    /**************************************************************
     SEND LOOP
     **************************************************************/
    function sendLoop(value){
       send("/input/loop/", value);
    }

    /**************************************************************
     SEND FORMAT
     **************************************************************/
    function sendFormat(value){
       send("/input/format/", value);
    }

    /**************************************************************
     SEND FLIP
     **************************************************************/
    function sendFlip(value){
       send("/input/flip/", value);
    }

    /**************************************************************
     SEND ROTATE
     **************************************************************/
    function sendRotate(value){
       send("/input/rotate/", value);
    }

    /**************************************************************
     SEND SCALE
     **************************************************************/
    function sendScale(value){
       send("/input/scale/", value);
    }

    /**************************************************************
     SEND TILT
     **************************************************************/
    function sendTilt(value){
       send("/input/tilt/", value);
    }
}
