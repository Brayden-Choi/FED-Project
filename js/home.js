$(document).ready(function () {
    let sm = new SlideManager("#overviewSlides", "#title-", "#overview-desc", "#overview-button");
    const filePath = "multimedia/home/overview.json";
    $.getJSON(filePath).then(function (data) {
        sm.setData(data);
        sm.setOverviewTexts();
        sm.$slide.on('slide.bs.carousel', function (event) {
            sm.slideChange(event);
        });
    }).fail(function () {
        console.log("Unable to load file: " + filePath);
    })
});

class SlideManager {
    constructor(slideId, titlePrefix, desc, button) {
        this.$slide = $(slideId);
        this.titlePrefix = titlePrefix;
        this.$desc = $(desc);
        this.$button = $(button);
        this.contentData = {};
        this.currentTitle = 1;
    }
 
    setData(data) {
        this.contentData = data;
        console.log("Data set to: ", this.contentData);
    }

    slideChange (event) {
        const targetData = $(event.relatedTarget).attr("content");
    
        let $top = this.getTitle(-1);
        let $current = this.getTitle(0);
        let $bottom = this.getTitle(1);
        
        this.currentTitle = mod(this.currentTitle + 1, 3);
        this.setOverviewTexts(event.relatedTarget);
    
        $top.addClass("title-hidden");
        $top.addClass("title-hidden-bottom");
        $top.removeClass("title-hidden-top");
    
        $current.addClass("title-hidden-top");
    
        $bottom.removeClass("title-hidden");
        $bottom.removeClass("title-hidden-bottom");
    }
    
    setOverviewTexts(targetItem) {
        if (targetItem === undefined) {
            targetItem = this.$slide.find(".active")[0];
        }
        
        const targetData = $(targetItem).attr("content");
        
        let $title = this.getTitle(0);
        $title.text(targetData);

        this.$desc.text(this.contentData[targetData].desc);
        this.$button.attr("href", this.contentData[targetData].page);
    }
    
    getTitle(offset) {
        return $(this.titlePrefix + mod(this.currentTitle + offset, 3));
    }
}

function mod(n, m) {
    return ((n % m) + m) % m;
}