document.addEventListener('turbolinks:load', function() {
  if (!document.querySelector('.page-mark.question-show-js')) return

  $('.question-content').on('ajax:success', function(e) {
    var respond = e.detail[0]
    $('#votable-rating-' + respond.id + ' .counter').html(respond.rating)
    if (respond.liked === true) {
      $('#votable-rating-' + respond.id + ' .like-link').css('color', 'green')
      $('#votable-rating-' + respond.id + ' .dislike-link').css('color', 'black')
    } else if (respond.liked === false) {
      $('#votable-rating-' + respond.id + ' .like-link').css('color', 'black')
      $('#votable-rating-' + respond.id + ' .dislike-link').css('color', 'red')
    } else {
      $('#votable-rating-' + respond.id + ' .like-link').css('color', 'black')
      $('#votable-rating-' + respond.id + ' .dislike-link').css('color', 'black')
    }
  })
})
