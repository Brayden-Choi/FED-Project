$(document).ready(function () {

    let currentShown = 1;

    $('#overviewSlides').on('slide.bs.carousel', function () {
        let $top = $("#title-" + mod(currentShown - 1, 3));
        let $current = $("#title-" + currentShown);
        let $bottom = $("#title-" + mod(currentShown + 1, 3));
        
        console.log(currentShown, mod(currentShown - 1, 3), currentShown, mod(currentShown + 1, 3));

        $top.addClass("title-hidden");
        $top.addClass("title-hidden-bottom");
        $top.removeClass("title-hidden-top");

        $current.addClass("title-hidden-top");

        $bottom.removeClass("title-hidden");
        $bottom.removeClass("title-hidden-bottom");
        
        currentShown = (currentShown + 1) % 3;
    })
});

function mod(n, m) {
    return ((n % m) + m) % m;
}