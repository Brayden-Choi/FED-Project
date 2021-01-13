$(document).ready(function () {
    // Cool letter hover
    var letters = $("#title-text").text();
    var nHTML = "";
    for (var letter of letters) {
        nHTML += "<span class='alter'>" + letter + "</span>";
    }
    $("#title-text").html(nHTML);
    
    // Parallax effect
    $(window).on('load scroll', function () {
        var scrolled = $(this).scrollTop();
        $('#title').css({
            'transform': 'translate3d(0, ' + -(scrolled * 0.2) + 'px, 0)', // parallax (20% scroll rate)
            'opacity': 1 - scrolled / 600 // fade out at 400px from top
        });
        $('#drone-vid-0').css(
            'transform', 'translate3d(0, ' + -(scrolled * 0.25) + 'px, 0)' // parallax (25% scroll rate)
        );
        $('#drone-vid-1').css(
            'transform', 'translate3d(0, ' + -(scrolled * 0.25) + 'px, 0)' // parallax (25% scroll rate)
        );
    });

    // Handle video change
    const vm = new VideoManager();
    $("#drone-vid-0").on('ended', function () {
        vm.swap();
    });
    $("#drone-vid-1").on('ended', function () {
        vm.swap();
    });
    
    // Handle section change
    const sm = new SectionManager("#content-indicators", ["#main", "#main-1"]);
    sm.indicatorScrollUpdate();
    $(window).scroll(function () {
        sm.indicatorScrollUpdate();
    });
    $('#content-indicators li').click(function (event) {
        sm.indicatorClick(event.target);
    });
    
    // Load attraction cards
    const am = new AttractionManager("#attractionCards", "#attractionsModal");
    const filePath = "multimedia/gardensbythebay/attractions.json";
    $.getJSON(filePath).then(function (data) {
        am.loadData(data);
    }).fail(function () {
        console.log("Unable to load file: " + filePath);
    })
});

class VideoManager {
    constructor() {
        this.currentVideo = 0
        this.currentShow = 0

        $("#drone-vid-0").fadeOut(0)
        $("#drone-vid-1").fadeOut(0)

        $("#drone-vid-0").trigger('play');
        $("#drone-vid-0").fadeIn(2000);
    }

    swap() {
        console.log("Video change");
        
        let endedVideo = $("#drone-vid-" + this.currentShow);
        endedVideo.trigger("pause");
        endedVideo.fadeOut(1000);
        
        this.currentShow = (++this.currentShow) % 2;
        let nextVideo = $("#drone-vid-" + this.currentShow);
        nextVideo.attr("src", "multimedia/gardensbythebay/drone-shots/drone_shot_" + (++this.currentVideo) + ".mp4")
        nextVideo.fadeIn(2000);
        
        nextVideo.trigger('play');

        this.currentVideo %= 4;
    }
}

class SectionManager {
    constructor(indicators, sections) {
        this.$indicators = $(indicators);
        this.sections = sections;
        this.currentSectionIndex = -1;
        this.$indicators.hide()
    }

    updateCurrentSection() {
        let currentY = $(window).scrollTop();
        let index = -1;
        for (let section of this.sections) {
            if ($(section).offset().top - currentY > 10) {
                this.currentSectionIndex = index;
                return;
            }
            index++;
        }
        this.currentSectionIndex = index;
    }

    setActive() {
        if (this.currentSectionIndex === -1) {
            this.$indicators.fadeOut(400);
            return;
        }
        
        if (!this.$indicators.is(":visible")) {
            this.$indicators.fadeIn(400);
        }
        
        for (let indicator of this.$indicators.find("li")) {
            if ($(indicator).index() == this.currentSectionIndex) {
                $(indicator).addClass("active");
                continue;
            }
            $(indicator).removeClass("active");
        }
    }
    
    indicatorClick(indicator) {
        let $indicator = $(indicator);
        if ($indicator.hasClass("indicator-hover")) {
            $indicator = $($indicator.parent());
        }
        if ($indicator.hasClass("indicator-hover-text")) {
            $indicator = $($indicator.parent().parent());
        }
        
        if (!$indicator.hasClass("indicator")) {
            console.log("Not an indicator:", $indicator);
            return;
        }
        
        let index = $indicator.index();
        console.log("Clicked on:", index)
        window.open(this.sections[index], "_self");
    }

    indicatorScrollUpdate() {
        this.updateCurrentSection();
        this.setActive();
    }
}


class AttractionManager {
    constructor(cardsId, modalId) {
        this.$cardCollection = $(cardsId);
        this.$modalView = $(modalId);
        this.data = {};
    }

    loadData(data) {
        this.data = data;
        
        let index = 0;
        for (const singleData of this.data) {
            this.$cardCollection.append(this.buildPreviewCard(singleData, index))
            console.log("Added card data:", singleData);
            index++;
        }
    }
    
    buildPreviewCard(cardData, index) {
        return `
        <div class="card">
            <img alt="..." class="card-img-top" src="${cardData.previewImage}">
            <div class="card-body">
                <h5 class="card-title">${cardData.name}</h5>
                <p class="card-text">${cardData.previewText}</p>
                <button class="btn btn-primary" data-target="#attractionsModal" data-toggle="modal" type="button" data-index="${index}">learn more!</button>
            </div>
        </div>
        `;
    }
}
