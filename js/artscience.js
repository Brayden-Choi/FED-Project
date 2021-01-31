data = [
    {
        "name": "Future World: Where Art Meets Science",
        "image": "multimedia/artscience-images/img1.jpg",
        "caption": "Immerse yourself in a world of art, science, magic and metaphor through a collection of digital interactive installation."
    },
    {
        "name": "Planet or Plastic?",
        "image": "multimedia/artscience-images/img2.jpg",
        "caption": "Learn about the global plastic pollution crisis through more than 70 powerful photographs and videos in an exhibition by National Geographic."
    },
    {
        "name": "STAR WARS Identities",
        "image": "multimedia/artscience-images/img3.jpg",
        "caption": "Create your unique Star Wars character in this interactive exhibition displaying close to 200 artefacts from the original Star Wars films. "
    },
    {
        "name": "Margins: drawing pictures of home",
        "image": "multimedia/artscience-images/img4.jpg",
        "caption": "Margins: drawing pictures of home presents the work of 15 contemporary photographers who reflect on topics important to Singapore today, particularly urgent during these uncertain times."
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
