/*global Xplain, jQuery*/

(function ($) {
    $("._parse_input").bind("keyup", function () {
        var $this = $(this), parsing, results = $("._parse_results");

        try {
            parsing = Xplain.Grammar.parse($this.val());
            results.removeClass("error");
        } catch (e) {
            parsing = e.message;
            results.addClass("error");
        }

        results.html(
            "[" + parsing + "]"
        );
    });
}(jQuery));