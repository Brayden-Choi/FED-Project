// Some helper functions
function mod(n, m) {
    return ((n % m) + m) % m;
}

// Ensure performance reliabilty
const debounce = (func, wait) => {
    let timeout;

    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };

        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
};

// Custom jquery methods
(function ($) {

    $.fn.isInViewport = function (options) {

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
            $text.html(nHTML);
        });
    };

}(jQuery));

// Manage Navbar behaviours
class NavManager {
    constructor(headerId) {
        this.$header = $(headerId);
        this.hasShadow = false;
        this.usingWhite = false;
    }
    
    setUp(navId, navContentId, navTogglerId) {
        this.$nav = $(navId);
        this.$navContent = $(navContentId);
        this.$navToggler = $(navTogglerId);
    }

    setActivePage() {
        let style = this.$header.data("type");

        if (style === "white") {
            this.usingWhite = true;
            this.$nav.addClass('navbar-white');
            this.$nav.addClass('navbar-dark');
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
        const canSee = this.$navToggler.attr("aria-expanded");
        const offset = this.$header.data("offset") || 30;

        if ($(window).scrollTop() >= offset) {
            if (this.usingWhite) {
                this.$nav.removeClass('navbar-white');
                this.$nav.removeClass('navbar-dark');
            }
            this.$nav.addClass('navbar-shadow');
            this.hasShadow = true;
        } else {
            if (canSee === "false") {
                if (this.usingWhite) {
                    this.$nav.addClass('navbar-white');
                    this.$nav.addClass('navbar-dark');
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
                this.$nav.removeClass('navbar-dark');
            }
            if (!this.hasShadow) {
                this.$nav.addClass('navbar-shadow');
            }
            return;
        }
        if (this.usingWhite && !this.hasShadow) {
            this.$nav.addClass('navbar-white');
            this.$nav.addClass('navbar-dark');
            this.$nav.removeClass('navbar-shadow');
        }
    }

    clickDropDown($dropDownToggle) {
        const dropDownID = $dropDownToggle.data("page");
        const targetPage = $dropDownToggle.data("link");

        let isCollapsed = this.$navToggler.is(":visible");
        if (!isCollapsed) {
            window.open(targetPage, "_self");
            return;
        }
        let dropDownMain = $($(dropDownID + " li")[0]).find('a:first')[0];
        if ($(dropDownMain).hasClass("show")) {
            console.log('closing dropdown...');
            $(dropDownMain).addClass("item-hidden");
            return;
        }
        console.log('opening dropdown...')
        $(dropDownMain).removeClass("item-hidden");
    }
}

$(document).ready(function () {
    const $window = $(window);

    // Event Handler to throttle scrolling event
    let previousScroll = undefined;
    $window.on('scroll', function () {
        const scrollPos = $(window).scrollTop();

        if (previousScroll === undefined || Math.abs(scrollPos - previousScroll) > 1) {
            $(window).trigger('usablescroll', scrollPos);
        }

        previousScroll = scrollPos;
    });
    
    // Setup navbar
    let nm = new NavManager("#header");
    nm.$header.load("header.html #nav", function () {
        nm.setUp("#nav", "#navbarContent", "#navbar-toggle-button");
        nm.setActivePage();
        nm.addNavShadow();

        $(window).on('resize usablescroll', debounce(function () {
            nm.addNavShadow();
        }, 20));

        nm.$nav.find(".dropdown-toggle").click(function (event) {
            nm.clickDropDown($(this));
        })

        nm.$navToggler.click(function (event) {
            nm.clickToggle();
        })
    });

    // Setup footer
    $("#footer").load("footer.html #foot");

    // Event Handler for smooth scrolling to an anchor
    $window.on('anchorscroll', function (event, anchorId, duration) {
        if (anchorId == undefined || anchorId == "") {
            return;
        }
        if (duration == undefined || duration < 0) {
            duration = 800;
        }

        const $anchor = $(anchorId);
        if ($anchor == undefined) {
            console.log("No such element with id:", hash);
            return;
        }

        if (history.pushState) {
            history.pushState(null, null, anchorId);
        } else {
            location.hash = anchor;
        }

        let offset = $anchor.data("offset");
        if (!offset && offset !== 0) {
            offset = nm.$nav.outerHeight() - 2;
        }

        console.log(`Doing smooth scrolling wiht offset ${offset}...`)
        $('html, body').animate({
            scrollTop: $anchor.offset().top - offset
        }, duration);
    });

    // Stop video if out of view
    $window.on('load resize usablescroll', debounce(function () {
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
    }, 250));
});

$(window).on('load', function (event) {
    // Add smooth scrolling to links
    $('.smooth-scrolling').on('click', function (event) {
        const hash = this.hash;
        if (hash == undefined || hash == "") {
            return;
        }
        
        // Change page dont do smooth scroll
        if (this.pathname !== window.location.pathname) {
            return;
        }

        event.preventDefault();
        $(window).trigger('anchorscroll', [hash]);
    });
    
    // If loaded window is anchor, do offset
    $(window).trigger('anchorscroll', [window.location.hash, 100]);
});
