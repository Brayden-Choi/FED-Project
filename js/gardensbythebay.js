$(document).ready(function () {
    
    $(window).on('load scroll', function () {
        var scrolled = $(this).scrollTop();
        $('#title').css({
            'transform': 'translate3d(0, ' + -(scrolled * 0.2) + 'px, 0)', // parallax (20% scroll rate)
            'opacity': 1 - scrolled / 600 // fade out at 400px from top
        });
        $('#drone-vid-0').css(
            'transform', 'translate3d(0, ' + -(scrolled * 0.25) + 'px, 0)' // parallax (25% scroll rate)
        );
        $('#drone-vid-1').css(
            'transform', 'translate3d(0, ' + -(scrolled * 0.25) + 'px, 0)' // parallax (25% scroll rate)
        );
    });

    let vm = new VideoManager();
    
    $("#drone-vid-0").on('ended', function () {
        vm.swap();
    });

    $("#drone-vid-1").on('ended', function () {
        vm.swap();
    });
});

class VideoManager {
    constructor() {
        this.currentVideo = 0
        this.currentShow = 0

        $("#drone-vid-0").fadeOut(0)
        $("#drone-vid-1").fadeOut(0)
        $("#drone-vid-0").fadeIn(2000);
        $("#drone-vid-0").trigger('play');
    }

    swap() {
        console.log("Video change");
        let endedVideo = $("#drone-vid-" + this.currentShow);
        endedVideo.trigger("pause");
        endedVideo.fadeOut(2000);
        
        this.currentShow = (++this.currentShow) % 2;
        let nextVideo = $("#drone-vid-" + this.currentShow);
        nextVideo.attr("src", "multimedia/gardensbythebay/drone-shots/drone_shot_" + (++this.currentVideo) + ".mp4")
        nextVideo.fadeIn(2000);
        
        nextVideo.trigger('play');

        this.currentVideo %= 4;
        
        console.log(nextVideo.duration)
    }
}