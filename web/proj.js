var request = new XMLHttpRequest();
var direction = -1;
function stop() {
        direction = 0;
        move();
}
function forward() {
        direction = 1;
        move();
}
function backward() {
        direction = 2;
        move();
}
function right() {
        direction = 3;
        move();
}
function left() {
        direction = 4;
        move();
}
function move() {
        request.onreadystatechange=function() {
                switch(request.readyState) {
                        case 1:
                                document.getElementById("request_state").innerHTML="Connecting...";
                                break;
                        case 2:
                                document.getElementById("request_state").innerHTML="Request received";
                                break;
                        case 3:
                                document.getElementById("request_state").innerHTML="Processing request...";
                                break;
                        case 4:
                                if (request.status==200) {
                                        switch(direction) {
                                                case 0:
                                                        document.getElementById("request_state").innerHTML="It should stop.";
                                                        break;
                                                case 1:
                                                        document.getElementById("request_state").innerHTML="It should move forward.";
                                                        break;
                                                case 2:
                                                        document.getElementById("request_state").innerHTML="It should move backward.";
                                                        break;
                                                case 3:
                                                        document.getElementById("request_state").innerHTML="It should turn right.";
                                                        break;
                                                case 4:
                                                        document.getElementById("request_state").innerHTML="It should turn left.";
                                                        break;
                                        }
                                } else {
                                        document.getElementById("request_state").innerHTML="Failed!";
                                }
                                break;
                }
        }
        request.open("GET", "move.php?dir=" + direction, true);
        request.send();
}
