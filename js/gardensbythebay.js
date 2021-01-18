class VideoManager {
    constructor() {
        this.currentVideo = 0
        this.currentShow = 0
        this.videoOutOfView = false;

        $("#drone-vid-0").fadeOut(0)
        $("#drone-vid-1").fadeOut(0)

        $("#drone-vid-0").trigger('play');
        $("#drone-vid-0").fadeIn(2000);
    }

    getCurrentVideo() {
        return $("#drone-vid-" + this.currentShow);
    }

    swap() {
        console.log("Video change");

        let $endedVideo = this.getCurrentVideo();
        $endedVideo.trigger("pause");
        $endedVideo.fadeOut(1000);

        this.currentShow = (++this.currentShow) % 2;
        let $nextVideo = this.getCurrentVideo();
        $nextVideo.attr("src", "multimedia/gardensbythebay/drone-shots/drone_shot_" + (++this.currentVideo) + ".mp4")
        $nextVideo.fadeIn(2000);

        $nextVideo.trigger('play');

        this.currentVideo %= 4;
    }

    checkOutOfView() {
        const contentInView = $("#content")[0].getBoundingClientRect().top < -10;
        if (contentInView && !this.videoOutOfView) {
            this.getCurrentVideo().trigger("pause");
            this.videoOutOfView = true;
            console.log("Title video paused.")
            return;
        } else if (!contentInView && this.videoOutOfView) {
            this.getCurrentVideo().trigger("play");
            this.videoOutOfView = false;
            console.log("Title video play.")
        }
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
            if ($(section).offset().top - currentY > 70) {
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
        $(window).trigger('anchorscroll', [this.sections[index]]);
    }

    indicatorScrollUpdate() {
        this.updateCurrentSection();
        this.setActive();
    }
}


class AttractionManager {
    constructor(cardsId, modalId, backgroundId) {
        this.cardsId = cardsId;
        this.$cardCollection = $(cardsId);
        this.modalId = modalId;
        this.$modalView = $(modalId);
        this.$background = $(backgroundId);
        this.data = {};
        this.cardImageDir = "multimedia/gardensbythebay/attraction-cards/";
    }

    loadData(data) {
        this.data = data;

        let index = 0;
        for (const singleData of this.data) {
            this.$cardCollection.append(this.buildPreviewCard(singleData, index))
            console.log("Added card data:", singleData);

            this.$cardCollection.append(this.getSeperator("sm", "md"));
            if (index % 2 === 1) {
                this.$cardCollection.append(this.getSeperator("md", "xl"));
            }
            if (index % 3 === 2) {
                this.$cardCollection.append(this.getSeperator("xl"));
            }
            index++;
        }
    }

    setBackground($card) {
        if (!$card.is(":hover")) {
            return;
        }

        const targetData = this.getData($card);
        this.$background.css("background-image", `url(${this.cardImageDir}${targetData.previewImage})`);
    }

    setModalData($button) {
        const targetData = this.getData($button)

        $(this.modalId + "-header").css("background-image", `linear-gradient(transparent, rgba(0, 0, 0, 0.6)), url(${this.cardImageDir}${targetData.previewImage})`);
        $(this.modalId + "-title").text(targetData.name);
        $(this.modalId + "-body").load(`gardensbythebay-attractions.html ${targetData.htmlId}`);

        console.log("Loaded modal data for:", targetData.name);
    }

    buildPreviewCard(cardData, index) {
        return `
        <div class="card" data-index="${index}">
            <img alt="..." class="card-img-top" src="${this.cardImageDir}${cardData.previewImage}">
            <div class="card-body">
                <h5 class="card-title">${cardData.name}</h5>
                <p class="card-text">${cardData.previewText}</p>
                <button class="btn btn-primary stretched-link" data-target="#attractionsModal" data-toggle="modal" type="button" data-index="${index}">learn more!</button>
            </div>
        </div>
        `;
    }

    getSeperator(warpTarget, previousTarget) {
        if (previousTarget === undefined) {
            return `<div class="w-100 mt-3 d-none d-${warpTarget}-block"></div>`;
        }
        return `<div class="w-100 mt-3 d-none d-${warpTarget}-block d-${previousTarget}-none"></div>`;
    }

    getData($idenifier) {
        return this.data[$idenifier.data("index")];
    }
}

$(document).ready(function () {
    // Cool letter hover
    var letters = $("#title-text").setLetterHoverEffect({"hoverClass": "title-alter-letter"});
    var letters = $(".header-text").setLetterHoverEffect({"hoverClass": "header-alter-letter"});

    // Handle video change
    const vm = new VideoManager();
    $("#drone-vid-0").on('ended', function () {
        vm.swap();
    });
    $("#drone-vid-1").on('ended', function () {
        vm.swap();
    });

    // Parallax effect
    $(window).on('load resize scroll', function () {
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
        vm.checkOutOfView();
    });

    // Handle section change
    const sm = new SectionManager("#content-indicators", ["#attractions", "#gallery", "#tickets"]);
    sm.indicatorScrollUpdate();
    $(window).scroll(function () {
        sm.indicatorScrollUpdate();
    });
    $('#content-indicators li').click(function (event) {
        sm.indicatorClick(event.target);
    });

    // Setup attraction cards
    const am = new AttractionManager("#attractionCards", "#attractionsModal", "#attractionsBackground");
    const filePath = "multimedia/gardensbythebay/data/attractions.json";
    $.getJSON(filePath).then(function (data) {
        am.loadData(data);
        $(`${am.cardsId} .card`).hover(function () {
            am.setBackground($(this));
        });
        am.$modalView.on('show.bs.modal', function (event) {
            am.setModalData($(event.relatedTarget));
        })
    }).fail(function () {
        console.log("Unable to load file: " + filePath);
    })

    $('.countrypicker').countrypicker();
});
