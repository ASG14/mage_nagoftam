/* =========================================
   NAVBAR SHADOW
========================================= */

const header = document.querySelector(".navbar");


if (header) {

    function updateHeader() {

        if (window.scrollY > 20) {

            header.style.boxShadow =
                "0 18px 55px rgba(25,28,35,.11)";

        } else {

            header.style.boxShadow =
                "0 25px 80px rgba(30,35,45,.08)";

        }

    }


    window.addEventListener(
        "scroll",
        updateHeader,
        { passive: true }
    );


    updateHeader();

}



/* =========================================
   STORY SLIDER
========================================= */

const storyCards =
    document.querySelectorAll(".story-card");

const storyDots =
    document.querySelectorAll(".story-dot");

const storyNext =
    document.getElementById("storyNext");

const storyPrev =
    document.getElementById("storyPrev");


let currentStory = 0;



function showStory(index) {

    if (!storyCards.length) {
        return;
    }


    if (index < 0) {

        index = storyCards.length - 1;

    }


    if (index >= storyCards.length) {

        index = 0;

    }


    storyCards.forEach(
        (card, i) => {

            card.classList.toggle(
                "active",
                i === index
            );

        }
    );


    storyDots.forEach(
        (dot, i) => {

            dot.classList.toggle(
                "active",
                i === index
            );

        }
    );


    currentStory = index;

}



/* Next */

if (storyNext) {

    storyNext.addEventListener(
        "click",
        () => {

            showStory(
                currentStory + 1
            );

        }
    );

}



/* Previous */

if (storyPrev) {

    storyPrev.addEventListener(
        "click",
        () => {

            showStory(
                currentStory - 1
            );

        }
    );

}



/* Dots */

storyDots.forEach(
    (dot, index) => {

        dot.addEventListener(
            "click",
            () => {

                showStory(index);

            }
        );

    }
);



/* =========================================
   KEYBOARD NAVIGATION
========================================= */

document.addEventListener(
    "keydown",
    (event) => {

        if (!storyCards.length) {
            return;
        }


        if (event.key === "ArrowRight") {

            showStory(
                currentStory + 1
            );

        }


        if (event.key === "ArrowLeft") {

            showStory(
                currentStory - 1
            );

        }

    }
);



/* =========================================
   INITIAL STATE
========================================= */

showStory(0);