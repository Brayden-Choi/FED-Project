"use strict";

function _classCallCheck(e, t) {
    if (!(e instanceof t)) throw new TypeError("Cannot call a class as a function")
}

var _createClass = function () {
    function e(e, t) {
        for (var i = 0; i < t.length; i++) {
            var l = t[i];
            l.enumerable = l.enumerable || !1, l.configurable = !0, "value" in l && (l.writable = !0), Object.defineProperty(e, l.key, l)
        }
    }

    return function (t, i, l) {
        return i && e(t.prototype, i), l && e(t, l), t
    }
}(), airSlider = function () {
    function e(t) {
        _classCallCheck(this, e), this.slider = document.querySelector(".air-slider"), this.slider.children[0].classList.toggle("active-slide"), this.length = document.querySelectorAll(".slide").length, void 0 == t.width && (t.width = "100%"), void 0 == t.height && (t.height = "300px"), this.slider.style.maxWidth = t.width, this.slider.style.height = t.height;
        var i = document.createElement("div");
        i.className = "controls", i.innerHTML = '<button id="prev"><</button><button id="next">></button>', this.slider.appendChild(i), document.querySelector("#prev").addEventListener("click", function () {
            slider.prev()
        }), document.querySelector("#next").addEventListener("click", function () {
            slider.next()
        }), 1 == t.autoPlay && (this.autoPlayTime = t.autoPlayTime, void 0 == this.autoPlayTime && (this.autoPlayTime = 3e3), setInterval(this.autoPlay, this.autoPlayTime))
    }

    return _createClass(e, [{
        key: "prev", value: function () {
            var e = document.querySelector(".active-slide"),
                t = document.querySelector(".active-slide").previousElementSibling;
            void 0 == t && (t = this.slider.children[this.length - 1]), e.className = "slide", t.classList = "slide active-slide"
        }
    }, {
        key: "next", value: function () {
            var e = document.querySelector(".active-slide"),
                t = document.querySelector(".active-slide").nextElementSibling;
            "controls" == t.className && (t = this.slider.children[0]), e.className = "slide", t.classList = "slide active-slide fadeIn"
        }
    }, {
        key: "autoPlay", value: function () {
            slider.next()
        }
    }]), e
}();

/*js for form*/
$(document).ready(function () {
    // Setup AOS animation
    // https://github.com/michalsnik/aos
    AOS.init();
    
    // Setup form
    $("#form-submit").click(function (event) {
        event.preventDefault();
        var salutation = document.getElementById("exampleInputSalutation").value;
        var lastname = document.getElementById("exampleInputLastName").value;
        document.getElementById("ack").innerHTML = "Thank you, " + salutation + " " + lastname + ". We will get back to you in 3-4 working days!"
    });

    $("#form-reset").click(function () {
        document.getElementById("ack").innerHTML = "";
    });
})


