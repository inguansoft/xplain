/*global Backbone*/

var Xplain = {};

Xplain.File = function (attrs) {
    var diagram;
    diagram = Backbone.Model.extend({
        defaults: attrs,
        initialize: function () {
        }
    });
};
