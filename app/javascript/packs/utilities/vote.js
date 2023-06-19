document.addEventListener('turbolinks:load', function() {
  if (!document.querySelector('.page-mark.questions-show-js')) return

  $('.question-content').on('ajax:success', function(e) {
    var respond = e.detail[0]
    if (respond.controller != 'voted') return
    $('#votable-' + respond.table + '-rating-' + respond.id + ' .counter').html(respond.rating)
    if (respond.liked === true) {
      $('#votable-' + respond.table + '-rating-' + respond.id + ' .like-link').css('color', 'green')
      $('#votable-' + respond.table + '-rating-' + respond.id + ' .dislike-link').css('color', 'black')
    } else if (respond.liked === false) {
      $('#votable-' + respond.table + '-rating-' + respond.id + ' .like-link').css('color', 'black')
      $('#votable-' + respond.table + '-rating-' + respond.id + ' .dislike-link').css('color', 'red')
    } else {
      $('#votable-' + respond.table + '-rating-' + respond.id + ' .like-link').css('color', 'black')
      $('#votable-' + respond.table + '-rating-' + respond.id + ' .dislike-link').css('color', 'black')
    }
  })
})
