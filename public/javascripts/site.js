$(document).ready(function() {
  var timer = $.timer(2000, function (timer) {
    $.getJSON((window.location +'.json'), function(data){
      $('.assets_count').html(data.site.assets_count);
      $('.errors_count').html(data.site.errors_count);
    });
  });
});