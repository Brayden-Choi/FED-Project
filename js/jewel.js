
$(document).ready(function () {
    $("#contactform").on("submit", function (event) {
        event.preventDefault();
        alert("Thank you for your feedback/questions, we will get back to you within 5 working days!");
        $("#contactform").trigger("reset");
    });
})