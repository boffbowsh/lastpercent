$(document).ready(function() {
  var timer = $.timer(2000, function (timer) {
    $.getJSON((window.location +'.json'), function(data){
      $('.box.assets em a').html('<span>' + data.site.assets_count + '</span>');
      $('.box.errors em a').html('<span>' + data.site.errors_count + '</span>');
    });
  });
});