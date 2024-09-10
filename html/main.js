$(function() {
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "tempomat") {
            if(item.state == 1){
                $('.tempomat').css('display', 'block');
                $(".tempo").html(item.speed);
            }else{
                $('.tempomat').css('display', 'none');
            }
            
        }
        if (item.type === "active") {
            $(".midtext").html(item.speed);
            $(".tank").html(item.fuel + "L")
            if (item.isEngine == 1) {
                $('.img1').attr('src', 'img/engineon.png');
            } else {
                $('.img1').attr('src', 'img/engineoff.png');
            }

            if (item.isLocked == 1) {
                $('.img2').attr('src', 'img/unlocked.png');
            } else {
                $('.img2').attr('src', 'img/locked.png');
            }
        }
        if (item.type === "showui") {
            $('#ui').css('display', 'block');
        }
        if (item.type === "deactive") {
            $('#ui').css('display', 'none');
        }
        if (event.data.action == "toggle") {
            setUISpawn(event.data.show)
        };
    })
})

function setUISpawn(show) {
    if (show) {
        $('#ui').css('display', 'block');
    } else {
        $('#ui').css('display', 'none');
    }
}