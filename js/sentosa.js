$(document).ready(function () {
    // Init animation function
    AOS.init();

    // form js
    $("#form-contact").on('submit', function (event) {
        event.preventDefault();
        
        var fname = document.getElementById('FirstName').value;
        var lname = document.getElementById('LastName').value;
        var email = document.getElementById('Email').value
        var contact = document.getElementById('ContactNo').value
        var comment = document.getElementById('Comment').value

        document.getElementById("acknowledgement").innerHTML = "Thank you for your feedback, " + fname;
    });

    $("#form-contact").on('reset', function (event) {
        document.getElementById("acknowledgement").innerHTML = " ";
    });
});