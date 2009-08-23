$(document).ready(function() {
  var open_id_field = $('form#new_user #field_openid_identifier');

  // Hide the open id field
  open_id_field.hide();

  $('form#new_user')
    .prepend('<a href="#" id="open_id_login_toggle">Sign in with Open ID</a>')
    .find('#open_id_login_toggle')
    .click(function() {
      
    open_id_field.show();
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
});