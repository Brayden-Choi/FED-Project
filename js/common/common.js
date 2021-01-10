let head = document.getElementById("head");

// Add header styles
let headerCSS = document.createElement("link");
headerCSS.setAttribute("rel", "stylesheet");
headerCSS.setAttribute("href", "css/header-styles.css");
head.appendChild(headerCSS);

console.log(head)

function doSetup() {
    $(document).ready(function () {
        $("#header").load("header.html #nav");
        console.log($("#header div.navbar-main"));
    });
}

doSetup();