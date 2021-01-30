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

function animateScroll() {
    $(document).on("click", "a", function (e) {
        e.preventDefault();
        var id = $(this).attr("href"),
            topSpace = 30;
        $('html, body').animate({
            scrollTop: $(id).offset().top - topSpace
        }, 800);
    });
}

function onSubmit() {
    alert("Thank you for your submission, our dedicated staff will get back to you soon!")
}