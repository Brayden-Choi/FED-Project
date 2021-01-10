// Add header styles
let head = document.getElementById("head");

let headerCSS = document.createElement("link");
headerCSS.setAttribute("rel", "stylesheet");
headerCSS.setAttribute("href", "css/header-styles.css");
head.appendChild(headerCSS);

// Add header to html
$(document).ready(function() {
    $("#header").load("header.html #nav", setActivePage);
});

$(window).scroll(function () {
    addNavShadow();
});

function setActivePage() {
    let targetPage = $("#header").attr("content").toLowerCase();
    let pages = $("#navbarSupportedContent ul li");
    
    for (let page of pages) {
        let pageName = $(page).find('a:first')[0].innerHTML.toLowerCase();
        if (pageName === targetPage) {
            $(page).addClass("active");
            break;
        }
    }

    addNavShadow();
}

function addNavShadow() {
    if ($(window).scrollTop() >= 30) {
        $('#nav').addClass('navbar-shadow');
    } else {
        $('#nav').removeClass('navbar-shadow');
    }
}