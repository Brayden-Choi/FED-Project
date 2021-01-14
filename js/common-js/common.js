function isElementInViewport(el) {
    // Special bonus for those using jQuery
    if (typeof jQuery === "function" && el instanceof jQuery) {
        el = el[0];
    }

    var rect = el.getBoundingClientRect();

    return (
        $(el).is(":visible") &&
        rect.bottom >= 0 &&
        rect.top <= (window.innerHeight || document.documentElement.clientHeight)
    );
}

class NavManager {
    constructor() {
        this.hasShadow = false;
        this.usingWhite = false;
    }

    setActivePage() {
        let style = $("#header").attr("type");

        if (style === "white") {
            this.usingWhite = true;
            $('#nav').addClass('navbar-white');
            $('#nav').addClass('navbar-dark');
        }

        let targetPage = $("#header").attr("content").toLowerCase();
        let pages = $("#navbarSupportedContent ul li");

        for (let page of pages) {
            let pageName = $(page).find('a:first')[0].innerHTML.toLowerCase();
            if (pageName === targetPage) {
                $(page).addClass("active");
                break;
            }
        }
    }

    addNavShadow() {
        let canSee = $("#navbar-toggle-button").attr("aria-expanded");

        if ($(window).scrollTop() >= 30) {
            if (this.usingWhite) {
                $('#nav').removeClass('navbar-white');
                $('#nav').removeClass('navbar-dark');
            }
            $('#nav').addClass('navbar-shadow');
            this.hasShadow = true;
        } else {
            if (canSee === "false") {
                if (this.usingWhite) {
                    $('#nav').addClass('navbar-white');
                    $('#nav').addClass('navbar-dark');
                }
                $('#nav').removeClass('navbar-shadow');
            }
            this.hasShadow = false;
        }
    }

    clickToggle() {
        let canSee = $("#navbar-toggle-button").attr("aria-expanded");

        if (canSee === "false") {
            if (this.usingWhite) {
                $('#nav').removeClass('navbar-white');
                $('#nav').removeClass('navbar-dark');
            }
            if (!this.hasShadow) {
                $('#nav').addClass('navbar-shadow');
            }
            return;
        }
        if (this.usingWhite && !this.hasShadow) {
            $('#nav').addClass('navbar-white');
            $('#nav').addClass('navbar-dark');
            $('#nav').removeClass('navbar-shadow');
        }
    }

    clickDropDown(dropDownID, targetPage) {
        let isCollapsed = $("#navbar-toggle-button").is(":visible");
        if (!isCollapsed) {
            window.open(targetPage, "_self");
            return;
        }
        let dropDownMain = $($(dropDownID + " li")[0]).find('a:first')[0];
        console.log(dropDownMain);
        if ($(dropDownID).hasClass("show")) {
            $(dropDownMain).addClass("dropdown-item-hidden");
            return;
        }
        $(dropDownMain).removeClass("dropdown-item-hidden");
    }
}

let navManager = new NavManager();

$(document).ready(function () {
    $("#header").load("header.html #nav", function () {
        navManager.setActivePage();
        navManager.addNavShadow();

        $(window).scroll(function () {
            navManager.addNavShadow();
        });

        // Stop video if out of view
        $(window).on('resize scroll', function () {
            for (let video of $('video')) {
                const $video = $(video);
                if ($video.css("position") === "fixed") {
                    continue;
                }

                if (isElementInViewport($video)) {
                    if (video.paused) {
                        console.log("video play.", video.id)
                        $video.trigger("play");
                    }
                } else {
                    if (!video.paused) {
                        console.log("video paused.", video.id)
                        $video.trigger("pause");
                    }
                }
            }
        });
    });
});

$(window).on('load', function (event) {
    // Add smooth scrolling to all links
    doSmoothScroll(window.location.hash, 0);
    $('.smooth-scrolling').on('click', function (event) {
        const hash = this.hash;

        console.log(this.page);

        if (hash == undefined || hash == "") {
            return;
        }

        console.log(this.pathname, window.location.pathname);
        if (this.pathname !== window.location.pathname) {
            return;
        }

        event.preventDefault();
        doSmoothScroll(hash, 800);
        window.location.hash = hash;
    });
});

function setAnchorOffset() {
    const $hash = $(window.location.hash);
    if ($hash == undefined) {
        return;
    }
    
    $('html, body').offset({top: getAnchorOffset($hash)});

}

function doSmoothScroll(hash, duration) {
    if (hash == undefined || hash == "") {
        return;
    }
    
    const $hash = $(hash);
    if ($hash == undefined) {
        console.log("No such element with id:", hash);
        return;
    }

    console.log("Doing smooth scrolling...")
    $('html, body').animate({
        scrollTop: getAnchorOffset($hash)
    }, duration);
}

function getAnchorOffset($hash) {
    return $hash.offset().top - 66
}