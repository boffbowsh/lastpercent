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
  
  $.excerpt();
  $.content_source();
});

$.extend({
  content_source: function() {
    $('pre[data-content-url]').each( function()
    {
      console.log(this);
      url = $(this).attr('data-content-url');
      $.get( url, function(data){
        lines = data.split('\n');
        padding = lines.length.toString().length + 1;
        numbered_lines = $.map( lines, function(n,i) {
          i += 1;
          gutter = Array(padding - i.toString().length).join(' ') + i.toString() + ': ';
          return gutter + n;
        });
        $(this).text(numbered_lines.join('\n'));
      }.bind(this) );
    });
  },
  
  excerpt: function() {
    $('pre[data-excerpt-line]').each( function()
    {
      url = $(this).attr('data-excerpt-url');
      line = parseInt($(this).attr('data-excerpt-line'));
      column = parseInt($(this).attr('data-excerpt-column'));
      range = parseInt($(this).attr('data-excerpt-range'));
      if ( isNaN(range) ) { range = 10 }
      $.get( url, function(data){
        lines = data.split('\n');
        padding = lines.length.toString().length + 1;
        numbered_lines = $.map( lines, function(n,i) {
          i += 1;
          gutter = Array(padding - i.toString().length).join(' ') + i.toString() + ': ';
          if ( i == line ) {
            new_n = n.slice(0,column-1);
            new_n += '$$BEGINCOLSPAN$$' + n.slice(column-1, column) + '$$ENDCOLSPAN$$';
            new_n += n.slice(column,n.length);
            return gutter + '$$BEGINLINESPAN$$' + new_n + '$$ENDLINESPAN$$';
          }
          else {
            return gutter + n;
          }
        });
        start = line - range - 1;
        if (start < 0) { start = 0 }
        end = line + range;
        console.log(range);
        sliced_lines = numbered_lines.slice(start, end);
        $(this).text(sliced_lines.join('\n'));
        html = $(this).html();
        html = html.replace('$$BEGINCOLSPAN$$', '<span class="current_column">');
        html = html.replace('$$BEGINLINESPAN$$', '<span class="current_line">');
        html = html.replace('$$ENDCOLSPAN$$', '</span>');
        html = html.replace('$$ENDLINESPAN$$', '</span>');
        $(this).html(html);
      }.bind(this));
    });
  }
});

// Make 'this' available within ajax calls
Function.prototype.bind = function(thisArg){
  var self = this;
  return function() { self.apply(thisArg, arguments); };
};