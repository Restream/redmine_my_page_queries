$(document).ready(function() {
  $("#content").on("ajax:complete", ".mypage-box", function(e, data) {
    if (data.status == 200) {
      var container = $(this).children('.handle')[0] || $(this);
      $(container).html(data.responseText);
    }
  });

  $('#content').on('click', '.edit-my-page-text', function(event) {
    event.preventDefault();
    $("#ajax-modal").html(window.myPageTextModal);
    showModal("ajax-modal", "60%");
    $('#my_page_text_area').focus();
    $("#ajax-modal").addClass("my-page-text");
  });
});
