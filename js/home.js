$(document).ready(function () {

    let overviewData = {};
    $.getJSON("multimedia/home/overview.json", function (data) {
        overviewData = data;
    }).fail(function () {
        console.log("Unable to load overview.json");
    });

    let currentShown = 1;

/*
    $("#title-" + currentShown).text(titles[currentTitle]);
*/

    $('#overviewSlides').on('slide.bs.carousel', function (event) {
        const targetData = $(event.relatedTarget).attr("content");
        
        let $top = $("#title-" + mod(currentShown - 1, 3));
        let $current = $("#title-" + currentShown);
        let $bottom = $("#title-" + mod(currentShown + 1, 3));
        
        console.log(targetData);

        currentShown = (currentShown + 1) % 3;
        $bottom.text(targetData);

        $top.addClass("title-hidden");
        $top.addClass("title-hidden-bottom");
        $top.removeClass("title-hidden-top");

        $current.addClass("title-hidden-top");

        $bottom.removeClass("title-hidden");
        $bottom.removeClass("title-hidden-bottom");
    })
});

function mod(n, m) {
    return ((n % m) + m) % m;
}