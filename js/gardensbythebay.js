String.prototype.capitalize = function () {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

class VideoManager {
    constructor() {
        this.currentVideo = 0
        this.currentShow = 0
        this.videoOutOfView = false;
        this.$title = $('#title');
        this.$arrow = $('#arrow');
        this.$vid0 = $("#drone-vid-0");
        this.$vid1 = $("#drone-vid-1");

        this.$vid0.fadeOut(0)
        this.$vid1.fadeOut(0)

        this.$vid0.trigger('play');
        this.$vid0.fadeIn(2000);
    }

    getCurrentVideo() {
        return this.currentShow === 0 ? this.$vid0 : this.$vid1;
    }

    swap() {
        console.log("Video changed.");

        let $endedVideo = this.getCurrentVideo();
        $endedVideo.trigger("pause");
        $endedVideo.fadeOut(1000);

        this.currentShow = (++this.currentShow) % 2;
        let $nextVideo = this.getCurrentVideo();
        $nextVideo.attr("src", `multimedia/gardensbythebay/drone-shots/drone_shot_${++this.currentVideo}.mp4`)
        $nextVideo.fadeIn(2000);

        $nextVideo.trigger('play');

        this.currentVideo %= 4;
    }

    checkOutOfView() {
        const contentInView = $("#attractions")[0].getBoundingClientRect().top < -10;
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
        return contentInView;
    }
}

class SectionManager {
    constructor(indicatorsId, contentId) {
        this.$indicators = $(indicatorsId);
        this.$content = $(contentId);
        this.sections = [];
        this.currentSectionIndex = -1;
        this.$indicators.hide();
        this.loadSections();
    }

    loadSections() {
        for (let section of this.$content.find("section")) {
            let sectionId = section.id;
            this.$indicators.append(this.buildIndicator(sectionId));
            this.sections.push(`#${sectionId}`);
        }

        console.log("loaded indicators.")
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

    buildIndicator(name) {
        return `
        <li class="indicator">
            <div class="indicator-hover">
                <p class="indicator-hover-text">${name.capitalize()}</p>
            </div>
        </li>
        `;
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
            console.log("Added card data:", singleData.name);

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
        <div class="card" data-index="${index}" data-aos="fade-up" data-aos-duration="600">
            <img alt="..." class="card-img-top" src="${this.cardImageDir}${cardData.previewImage}">
            <div class="card-body">
                <h5 class="card-title">${cardData.name}</h5>
                <p class="card-text">${cardData.previewText}</p>
                <button class="btn btn-danger stretched-link attractions-btn" data-target="#attractionsModal" data-toggle="modal" type="button" data-index="${index}">
                    Learn More
                    <i class="fa fa-chevron-circle-right"></i>
                </button>
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

class TicketManager {
    constructor(ticketId) {
        this.$ticketForm = $(ticketId);
        this.$ticketOptions = $(`${ticketId}-options`);
        this.$ticketItems = $(`${ticketId}-items`);
        this.$ticketCount = $(`${ticketId}-count`);
        this.$ticketSubTotal = $(`${ticketId}-subtotal`);
        this.$ticketTotal = $(`${ticketId}-total`);
        this.itemList = [];
        this.dropdownDivider = `<div class="dropdown-divider"></div>`;

        this.calcuateOrderSummary();
    }

    setUpData(data) {
        this.data = data;

        for (let index = 0; index < this.data.length; index++) {
            this.$ticketOptions.append(this.buildTicketOption(index))
            if (index != this.data.length - 1) {
                this.$ticketOptions.append(this.dropdownDivider);
            }
        }
    }

    addTicketItem($ticketOption) {
        const item = new TicketItem(this, $ticketOption);
        item.$minusButton.click(function () {
            item.quantityMinus();
        });
        item.$plusButton.click(function () {
            item.quantityPlus();
        });
        item.$removeButton.click(function () {
            item.remove();
        });

        this.itemList.unshift(item);
        this.calcuateOrderSummary();

        $(this.$ticketOptions.find("a")[item.index]).addClass("disabled");

        console.log("Added ticket item.");
    }

    removeTicketItem(index) {
        const targetItem = this.itemList[index];

        this.itemList.splice(index, 1);
        this.calcuateOrderSummary();

        $(this.$ticketOptions.find("a")[targetItem.index]).removeClass("disabled");

        targetItem.$item.on('transitionend webkitTransitionEnd oTransitionEnd', function () {
            $(this).delay(300).queue(function (next) {
                $(this).remove();
                console.log("Removed ticket item: ", index);
                next();
            });
        });
    }

    calcuateOrderSummary() {
        if (this.itemList.length === 0) {
            this.$ticketCount.text(0);
            this.$ticketSubTotal.text("SGD -.--");
            this.$ticketTotal.text("SGD -.--");
            return;
        }

        let totalTickets = 0;
        let totalPrice = 0;
        for (let item of this.itemList) {
            console.log(item);
            totalTickets += item.getCurrentQuantity();
            totalPrice += item.calculatePrice();
        }
        this.$ticketCount.text(totalTickets);
        this.$ticketSubTotal.text(this.parseMoney(totalPrice));
        this.$ticketTotal.text(this.parseMoney(totalPrice));
    }

    parseMoney(value) {
        return `SGD ${value.toFixed(2)}`;
    }

    buildTicketOption(index) {
        const ticketData = this.data[index];
        return `
        <a class="dropdown-item" href="#" data-index="${index}">
            <div class="row">
                <div class="col-8 pl-1">
                    <h6 class="list-content-text">${ticketData.name}</h6>
                    <p class="list-content-text">${ticketData.type} / ${ticketData.age}</p>
                </div>
                <div class="col-4 my-auto mr-0 pl-md-5 pr-1">
                    <h6 class="mb-0 float-md-right">${this.parseMoney(ticketData.price)}</h6>
                </div>
            </div>
        </a>
        `;
    }
}

class TicketItem {
    constructor(manager, $ticketOption) {
        this.manager = manager;

        this.index = $ticketOption.data("index");
        this.itemData = this.manager.data[this.index];

        this.manager.$ticketItems.prepend(this.buildTicketItem());

        this.$item = this.manager.$ticketItems.find("li").first();
        this.$quantityObj = $(`#item-quantity-${this.index}`);
        this.$minusButton = $(`#btn-minus-${this.index}`);
        this.$plusButton = $(`#btn-plus-${this.index}`);
        this.$removeButton = $(`#btn-remove-${this.index}`);

        this.quanityMin = 1;
        this.quanityMax = 8;

        this.updateQuantityState();
    }

    updateQuantityState() {
        const currentQuantity = this.getCurrentQuantity();

        if (currentQuantity <= this.quanityMin) {
            this.$minusButton.addClass("disabled");
        } else {
            this.$minusButton.removeClass("disabled");
        }

        if (currentQuantity >= this.quanityMax) {
            this.$plusButton.addClass("disabled");
        } else {
            this.$plusButton.removeClass("disabled");
        }

        this.manager.calcuateOrderSummary();
    }

    quantityMinus() {
        console.log("clicked on minus.");
        return this.updateCurrentQuantity(-1);
    }

    quantityPlus() {
        console.log("clicked on plus.");
        return this.updateCurrentQuantity(1);
    }

    isWithinLimit(by) {
        const newValue = this.getCurrentQuantity() + by;
        return newValue >= this.quanityMin && newValue <= this.quanityMax;
    }

    updateCurrentQuantity(amount) {
        if (!this.isWithinLimit(amount)) {
            return false;
        }
        this.$quantityObj.text(this.getCurrentQuantity() + amount);
        this.updateQuantityState();
        this.manager.calcuateOrderSummary();
        return true;
    }

    getCurrentQuantity() {
        return parseInt(this.$quantityObj.text());
    }

    calculatePrice() {
        return this.getCurrentQuantity() * this.itemData.price;
    }

    remove() {
        this.$item.addClass("ticket-item-disappear");
        this.manager.removeTicketItem(this.$item.index());
    }

    buildTicketItem() {
        return `
        <li class="list-group-item ticket-item">
            <div class="row m-0">
                <div class="col-11 p-0 pl-md-3 pl-sm-1">
                    <div class="row m-0">
                        <div class="col-md-9 my-auto p-0">
                            <div class="row">
                                <h5 class="list-content-text">${this.itemData.name}</h5>
                            </div>
                            <div class="row">
                                <p class="list-content-text">${this.itemData.type} / ${this.itemData.age}</p>
                            </div>
                            <div class="row">
                                <h5 class="list-content-text pt-2">SGD ${this.itemData.price.toFixed(2)}</h5>
                            </div>
                        </div>

                        <div class="col-md-3 my-auto p-0 quantity-selector">
                            <button class="btn btn-sm btn-info btn-stepper-minus" id="btn-minus-${this.index}" type="button"">
                                <i class="fa fa-minus"></i>
                            </button>
                            <h5 class="item-quantity" id="item-quantity-${this.index}">1</h5>
                            <button class="btn btn-sm btn-info btn-stepper-plus" id="btn-plus-${this.index}" type="button"">
                                <i class="fa fa-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-1 my-auto p-0 pr-sm-2 pr-md-0">
                    <button class="btn btn-round ticket-remove float-md-right" id="btn-remove-${this.index}" type="button"">
                        <i class="fa fa-close"></i>
                    </button>
                </div>
            </div>
        </li>
        `;
    }
}

$(document).ready(function () {
    // Cool letter hover
    var letters = $("#title-text").setLetterHoverEffect({"hoverClass": "title-alter-letter"});
    var letters = $(".header-text").setLetterHoverEffect({"hoverClass": "header-alter-letter"});

    // Handle section indicators
    const sm = new SectionManager("#content-indicators", "#content");
    sm.indicatorScrollUpdate();
    $(window).scroll(debounce(function () {
        sm.indicatorScrollUpdate();
    }, 128));
    sm.$indicators.click(function (event) {
        sm.indicatorClick(event.target);
    });

    // Handle video change
    const vm = new VideoManager();
    vm.$vid0.on('ended', function () {
        vm.swap();
    });
    vm.$vid1.on('ended', function () {
        vm.swap();
    });

    // Parallax effect
    $(window).on('load resize usablescroll', debounce(function (event, scrollPos) {
        if (vm.checkOutOfView()) {
            return;
        }

        vm.$title.css({
            'transform': 'translate(0, ' + -(scrollPos * 0.2) + 'px)', // parallax (20% scroll rate)
            'opacity': 1 - scrollPos / 600 // fade out at 400px from top
        });
        vm.$arrow.css({
            'opacity': 1 - scrollPos / 600 // fade out at 400px from top
        });

        if (scrollPos >= 920) {
            vm.$vid0.css(
                'transform', 'translate(0, ' + -((scrollPos - 920) * 0.25) + 'px)' // parallax (25% scroll rate)
            );
            vm.$vid1.css(
                'transform', 'translate(0, ' + -((scrollPos - 920) * 0.25) + 'px)' // parallax (25% scroll rate)
            );
        } else {
            vm.$vid0.css(
                'transform', 'translate(0, 0)'
            );
            vm.$vid1.css(
                'transform', 'translate(0, 0)'
            );
        }
    }, 12));

    // Setup attraction cards
    const am = new AttractionManager("#attractionCards", "#attractionsModal", "#attractionsBackground");
    const attractionPath = "multimedia/gardensbythebay/data/attractions.json";
    $.getJSON(attractionPath).then(function (data) {
        am.loadData(data);
        $(`${am.cardsId} .card`).hover(function () {
            am.setBackground($(this));
        });
        am.$modalView.on('show.bs.modal', function (event) {
            am.setModalData($(event.relatedTarget));
        })
    }).fail(function () {
        console.log("Unable to load file: " + attractionPath);
    })

    // Setup ticket form
    const tm = new TicketManager("#tickets");
    const ticketPath = "multimedia/gardensbythebay/data/attractions-tickets.json";
    $.getJSON(ticketPath).then(function (data) {
        tm.setUpData(data);
        tm.$ticketOptions.find("a").click(function (event) {
            event.preventDefault();
            tm.addTicketItem($(this));
        });
    }).fail(function () {
        console.log("Unable to load file: " + ticketPath);
    })

    // Setup picker 
    // https://github.com/mojoaxel/bootstrap-select-country
    $('.countrypicker').countrypicker();

    // Setup AOS animation
    // https://github.com/michalsnik/aos
    AOS.init({debounceDelay: 76, throttleDelay: 128});
});
