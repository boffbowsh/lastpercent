$(document).ready(function() {
  var open_id_register = $('form#new_user #field_openid_identifier');
  var open_id_signup = $('form#new_user_session #field_openid_identifier');

  // Hide the open id field
  open_id_register.hide();
  open_id_signup.hide();

  $('form#new_user')
    .prepend('<a href="#" class="button" id="open_id_login_toggle">Register with Open ID</a>')
    .find('#open_id_login_toggle')
    .click(function() {
      
    $('form#new_user .fields').toggle();
    open_id_register.toggle();
    return false;
  });
  
  $('form#new_user_session')
    .prepend('<a href="#" class="button" id="open_id_login_toggle">Sign in with Open ID</a>')
    .find('#open_id_login_toggle')
    .click(function() {
     
     $('form#new_user_session .fields').toggle(); 
    open_id_signup.toggle();
    return false;
  });

  // open external links in a new window/tab
  $('a[rel="external"]').live('click', function(){
    window.open($(this).attr('href'));
    return false;
  });

  // lightbox setup
  $('a.lightbox').fancybox({
    hideOnContentClick: false,
    frameWidth: 600,
    frameHeight: 400
  });
  
  $('#excerpt').excerpt('/system/datas/152915/original/http_www.neocol.com_?1253135364', 20, 6, 10);
});

$.fn.extend({
  excerpt: function( url, line, column, range ){
    $.get( url, function(data){
      lines = data.split('\n');
      padding = lines.length.toString().length + 1;
      numbered_lines = $.map( lines, function(n,i) {
        i += 1;
        return Array(padding - i.toString().length).join('0') + i.toString() + ': ' + n;
      });
      start = line - range;
      if (start < 0) { start = 0 }
      end = line + range;
      console.log([start, end].join(','))
      sliced_lines = numbered_lines.slice(start, end)
      this.text(sliced_lines.join('\n'));
    }.bind(this));
  }
});

// Make 'this' available within ajax calls
Function.prototype.bind = function(thisArg){
  var self = this;
  return function() { self.apply(thisArg, arguments); };
};