
$(document).ready(function () {
    $("#contactform").on("submit", function (event) {
        event.preventDefault();
        alert("Thank you for your feedback/questions, we will get back to you within 5 working days!");
        $("#form").trigger("reset");
    });
});

    $("#contactform").on('reset', function (event) {
        document.getElementById("p").innerHTML = "";
    });
})