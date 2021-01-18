$(function () {
    var $carousel = $(".carousel");
    var slider;

    $carousel.slick({
        speed: 300,
        height: 200,
        arrows: false,
        slidesToShow: 2
    });

    slider = $(".slider").slider({
        min: 0,
        max: 5,
        slide: function (event, ui) {
            var slick = $carousel.slick("getSlick");
            goTo = ui.value * (slick.slideCount - 1) / 5;
            console.log(goTo);
            $carousel.slick("goTo", goTo);
        }
    });
});