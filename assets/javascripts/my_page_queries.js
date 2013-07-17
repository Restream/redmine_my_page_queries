$(document).ready(function() {
  $("#content").on("ajax:complete", ".mypage-box", function(e, data) {
    if (data.status == 200) {
      var container = $(this).children('.handle')[0] || $(this);
      $(container).html(data.responseText);
    }
  });
});
