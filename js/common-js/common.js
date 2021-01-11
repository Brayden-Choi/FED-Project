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
        }
        else {
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
}

let navManager = new NavManager();

$(document).ready(function() {
    
    $("#header").load("header.html #nav", function () {
        navManager.setActivePage();
        navManager.addNavShadow();
    });

    $(window).scroll(function () {
        navManager.addNavShadow();
    });
});
