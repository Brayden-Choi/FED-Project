// form js

function GetInput()
{
    var fname = document.getElementById('FirstName').value;

    var lname = document.getElementById('LastName').value;

    var email = document.getElementById('Email').value

    var contact = document.getElementById('ContactNo').value

    var comment = document.getElementById('Comment').value

    document.getElementById("acknowledgement").innerHTML = "Thank you for your feedback, " + fname;
}