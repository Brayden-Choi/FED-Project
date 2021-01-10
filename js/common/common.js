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

function setActivePage() {
    let targetPage = $("#header").attr("content").toLowerCase();
    let pages = $("#navbarSupportedContent ul li");

    console.log(pages)
    console.log(pages.length)
    
    for (let page of pages) {
        let pageName = $(page).find('a:first')[0].innerHTML.toLowerCase();
        if (pageName === targetPage) {
            $(page).addClass("active")
            break;
        }
    }
}
