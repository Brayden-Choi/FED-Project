data = [
    {
        "name": "Something",
        "image": "multimedia/artscience-images/cutoutlogo.png",
        "caption": "Amazing"
    },
    {
        "name": "2Something",
        "image": "multimedia/artscience-images/img2.jpg",
        "caption": "2Amazing"
    }
]


$(document).ready(function () {
    console.log("Ready");
    
    // modal polaroid appear
    $(".polaroid").on("click", function (event) {
        const dataIndex = $(this).data("index");
        console.log(dataIndex);

        $("#modal-title").text(data[dataIndex]["name"]);
        $("#modal-caption").text(data[dataIndex]["caption"]);
        $("#modal-image").attr("src", data[dataIndex]["image"])
    });
    
    $("#form").on("submit", function (event) {
        event.preventDefault();
        alert("Thank you for your submission, our dedicated staff will get back to you soon!");
        $("#form").trigger("reset");
    });
});


/*
function modal() {
    // Get the modal
    var modal = document.getElementById('myModal');

    // Get the image and insert it inside the modal - use its "alt" text as a caption
    var img = $('.myImg');
    var modalImg = $("#img01");
    var captionText = document.getElementById("caption");
    $('.myImg').click(function () {
        modal.style.display = "block";
        var newSrc = this.src;
        modalImg.attr('src', newSrc);
        captionText.innerHTML = this.alt;
    });

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];

    // When the user clicks on <span> (x), close the modal
    span.onclick = function () {
        modal.style.display = "none";
    }
}

function onSubmit() {
    alert("Thank you for your submission, our dedicated staff will get back to you soon!")
}*/
