// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery-ui
// require jquery_ujs
//= require bootstrap-datepicker
// require turbolinks
//= require_tree .
jQuery.noConflict();
var datatableAjaxError = function (xhr, textStatus, errorThrown) {
    var msg = JSON.parse(xhr.responseText);
    var key = Object.keys(msg)[0];
    var value = msg[Object.keys(msg)[0]];
    alert(key+' : '+value);
}



$(document).ajaxError(function(event,xhr,options,exc) {

    var errors = JSON.parse(xhr.responseText);
    var er ="<ul>";
    for(var i = 0; i < errors.length; i++){
        var list = errors[i];
        er += "<li>"+list+"</li>"
    }
    er+="</ul>"
    $("#error_explanation").html(er);

});
