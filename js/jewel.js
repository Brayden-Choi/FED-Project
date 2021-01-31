
$(document).ready(function () {
    $("#contactform").on("submit", function (event) {
        event.preventDefault();
        alert("Thank you for your submission, our dedicated staff will get back to you soon!");
        $("#form").trigger("reset");
    });
});

    $("#contactform").on('reset', function (event) {
        document.getElementById("p").innerHTML = "";
    });
})