$(document).ready(function() {
  var timer = $.timer(5000, function (timer) {
    $.getJSON((window.location +'.json'), function(data){
      if (data.site.spider_failed_at != null ||  data.site.spider_ended_at != null) {
        timer.stop();
      }
      else {
        $('.box.assets em a').html('<span>' + data.site.assets_count + '</span>');
        $('.box.errors em a').html('<span>' + data.site.errors_count + '</span>');
        $('.box.warnings em a').html('<span>' + data.site.warnings_count + '</span>');
      }
    });
  });
});