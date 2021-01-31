
$(document).ready(function () {
    $("#form-submit").on('submit', function (event) {
        event.preventDefault();
        var name = document.getElementById("contact_nom").value;
        document.getElementById("output").innerHTML = "Thank you " + name + ". We will get back to you within 5 days!"
    });

    $("#contact-form").on('reset', function (event) {
        document.getElementById("p").innerHTML = "";
    });
})