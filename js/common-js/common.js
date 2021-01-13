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

// Add header styles
let head = document.getElementById("head");

let headerCSS = document.createElement("link");
headerCSS.setAttribute("rel", "stylesheet");
headerCSS.setAttribute("href", "css/header-styles.css");
head.appendChild(headerCSS);

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
    });

    $(window).scroll(function () {
        navManager.addNavShadow();
    });
    
    // Stop video if out of view
    $(window).on('resize scroll', function () {
        for (let video of $('video')) {
            const $video = $(video);
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