class SlideManager {
    constructor(slideId, slideImagesId, titlePrefix, desc, button, indicators) {
        this.$slide = $(slideId);
        this.$slideImages = $(slideImagesId);
        this.titlePrefix = titlePrefix;
        this.$desc = $(desc);
        this.$button = $(button);
        this.$indicators = $(indicators);
        this.contentData = {};
        this.currentTitle = 1;
    }

    loadData(data) {
        this.contentData = data;
        console.log("Data set to: ", this.contentData);
        //TODO: Loop through kv pair of data and load slide image + indicator
        let index = 0;
        
        console.log(this.contentData);
        let active = true;
        for (const singleData of this.contentData) {
            console.log(singleData);
            this.$slideImages.append(this.buildSlideImage(index, singleData, active));
            this.$indicators.append(this.buildSlideIndicator(index));
            
            active = false;
            index++;
        }
        
        this.setOverviewTexts();
    }

    slideChange(event) {
        const targetData = $(event.relatedTarget).attr("content");

        let $top = this.getTitle(-1);
        let $current = this.getTitle(0);
        let $bottom = this.getTitle(1);

        this.currentTitle = mod(this.currentTitle + 1, 3);
        this.setOverviewTexts($(event.relatedTarget));

        $top.addClass("title-hidden");
        $top.addClass("title-hidden-bottom");
        $top.removeClass("title-hidden-top");

        $current.addClass("title-hidden-top");

        $bottom.removeClass("title-hidden");
        $bottom.removeClass("title-hidden-bottom");
    }

    setOverviewTexts($targetItem) {
        if ($targetItem === undefined) {
            $targetItem = $(this.$slide.find(".active")[0]);
        }

        const targetIndex = $targetItem.data("index");
        const data = this.contentData[targetIndex];
        
        let $title = this.getTitle(0);
        $title.text(data.name);

        this.$desc.text(data.desc);
        
        const targetPage = data.page;
        if (targetPage === "") {
            this.$button.addClass("item-hidden");
        }
        else {
            this.$button.removeClass("item-hidden");
            this.$button.attr("href", data.page);
        }

        let activeIndex = $targetItem.index() - 1;
        let index = 0;
        for (let indicator of this.$indicators.find("li")) {
            if (index++ === activeIndex) {
                $(indicator).addClass("active");
                continue;
            }
            $(indicator).removeClass("active");
        }
    }

    getTitle(offset) {
        return $(this.titlePrefix + mod(this.currentTitle + offset, 3));
    }

    buildSlideIndicator(index) {
        return `<li class="indicator" data-slide-to="${index}" data-target="#overview-slides"></li>`;
    }

    buildSlideImage(index, data, active) {
        return `
        <div class="carousel-item${active ? " active" : ""}" data-index="${index}">
            <div class="overview-overlay"></div>
            <img alt="${data.name}" class="d-block w-100 min-vh-100" src="multimedia/home/overview-slides/${data.imageFile}">
        </div>
        `;
    }
}

$(document).ready(function () {
    let sm = new SlideManager("#overview-slides", "#overview-slides-data", "#title-", "#overview-desc", "#overview-button", "#overview-indicators");
    const filePath = "multimedia/home/overview.json";
    $.getJSON(filePath).then(function (data) {
        sm.loadData(data);
        sm.$slide.on('slide.bs.carousel', function (event) {
            sm.slideChange(event);
        });
    }).fail(function () {
        console.log("Unable to load file: " + filePath);
    })
});
