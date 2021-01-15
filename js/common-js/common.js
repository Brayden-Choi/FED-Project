// Custom jquery methods
(function ($) {
    
    $.fn.isInViewport = function (options) {

        // Options with default
        let settings = $.extend({
            inFull: false,
        }, options);
        
        const el = this[0];
        var rect = el.getBoundingClientRect();

        if (!$(el).is(":visible")) {
            return false;
        }
        
        if (settings.inFull) {
            return (
                rect.top >= 0 &&
                rect.bottom <= (window.innerHeight || document.documentElement.clientHeight)
            );
        }

        console.log(window.innerHeight, document.documentElement.clientHeight);
        return (
            rect.bottom >= 0 &&
            rect.top <= (window.innerHeight || document.documentElement.clientHeight)
        );
    };

    $.fn.setLetterHoverEffect = function (options) {
        
        let settings = $.extend({
            hoverClass: undefined,
        }, options);
        
        this.each(function () {
            let $text = $(this);
            let nHTML = "";
            for (var letter of $text.text()) {
                nHTML += `<span class="${settings.hoverClass}">${letter}</span>`;
            }
            console.log(nHTML);
            $text.html(nHTML);
        });
    };
    
}(jQuery));

// Manage Navbar behaviours
class NavManager {
    constructor(headerId, navId, navContentId, navTogglerId) {
        this.$header = $(headerId);
        this.$nav = $(navId);
        this.$navContent = $(navContentId);
        this.$navToggler = $(navTogglerId);
        this.hasShadow = false;
        this.usingWhite = false;
    }

    setActivePage() {
        let style = this.$header.attr("type");

        if (style === "white") {
            this.usingWhite = true;
            this.$nav.addClass('navbar-white');
        }

        let targetPage = this.$header.attr("content").toLowerCase();
        let pages = this.$navContent.find("ul li");

        for (let page of pages) {
            let pageName = $(page).find('a:first')[0].innerHTML.toLowerCase();
            if (pageName === targetPage) {
                $(page).addClass("active");
                break;
            }
        }
    }

    addNavShadow() {
        let canSee = this.$navToggler.attr("aria-expanded");

        if ($(window).scrollTop() >= 30) {
            if (this.usingWhite) {
                this.$nav.removeClass('navbar-white');
            }
            this.$nav.addClass('navbar-shadow');
            this.hasShadow = true;
        } else {
            if (canSee === "false") {
                if (this.usingWhite) {
                    this.$nav.addClass('navbar-white');
                }
                this.$nav.removeClass('navbar-shadow');
            }
            this.hasShadow = false;
        }
    }

    clickToggle() {
        let canSee = this.$navToggler.attr("aria-expanded");

        if (canSee === "false") {
            if (this.usingWhite) {
                this.$nav.removeClass('navbar-white');
            }
            if (!this.hasShadow) {
                this.$nav.addClass('navbar-shadow');
            }
            return;
        }
        if (this.usingWhite && !this.hasShadow) {
            this.$nav.addClass('navbar-white');
            this.$nav.removeClass('navbar-shadow');
        }
    }

    clickDropDown($dropDownToggle) {
        const dropDownID = $dropDownToggle.data("target");
        const targetPage = $dropDownToggle.data("link");
        
        let isCollapsed = this.$navToggler.is(":visible");
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

$(document).ready(function () {
    // Setup navbar
    $("#header").load("header.html #nav", function () {
        let nm = new NavManager("#header", "#nav", "#navbarContent", "#navbar-toggle-button");
        
        nm.setActivePage();
        nm.addNavShadow();

        $(window).scroll(function () {
            nm.addNavShadow();
        });
        
        nm.$nav.find(".dropdown-toggle").click(function (event) {
            event.preventDefault();
            nm.clickDropDown($(this));
        })
    });
});

$(window).on('load', function (event) {
    // Stop video if out of view
    $(window).on('resize scroll', function () {
        for (let video of $('video')) {
            const $video = $(video);
            if ($video.css("position") === "fixed") {
                continue;
            }

            if ($video.isInViewport()) {
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
    
    // Add smooth scrolling to all links
    $(window).trigger('anchorscroll', [window.location.hash, 100]);
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
        $(window).trigger('anchorscroll', [hash]);
    });
});

// Event Handler for smooth scrolling to an anchor
$(window).on('anchorscroll', function (event, anchor, duration) {
    if (anchor == undefined || anchor == "") {
        return;
    }
    if (duration == undefined || duration < 0) {
        duration = 800;
    }
    
    const $anchor = $(anchor);
    if ($anchor == undefined) {
        console.log("No such element with id:", hash);
        return;
    }

    if (history.pushState) {
        history.pushState(null, null, anchor);
    } else {
        location.hash = anchor;
    }
    
    console.log("Doing smooth scrolling...")
    $('html, body').animate({
        scrollTop: $anchor.offset().top - $('#nav').outerHeight() + 5
    }, duration);
});
