import consumer from "./consumer"

consumer.subscriptions.create("QuestionsShowChannel", {
  connected() {
    var questionId = gon.question_id
    if (!questionId) return

    this.perform('questions_show_follow', { question_id: questionId })
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (!document.querySelector('.page-mark.questions-show-js')) return

    if (data.controller === 'answers_controller') answersController(data)
    if (data.controller === 'commented') commented(data)
    if (data.controller === 'comments_controller') commentsController(data)
  }
});

function answersController(data) {
  if (data.action === 'create') answersControllerCreate(data)
}

function answersControllerCreate(data) {
  // Prevent answer's author to see this answer from broadcast
  if (data.user_id == gon.user_id) return

  if (data.question.user_id == gon.user_id) {
    data.question_user_eq_current_user = true
  }
  if ((gon.user_id != null) && (data.user_id != gon.user_id)) {
    data.current_user_exists_and_resource_user_not_eq_current_user = true
  }
  $('.answers').append(require("../packs/templates/answers/show.handlebars")({ answer: data }))
  $('#answers-' + data.id + ' .comments .new form .authenticity-token').replaceWith($('.page-template .authenticity-token-template input').clone(true))
}

function commented(data) {
  if (data.action === 'create') commentedCreate(data)
}

function commentedCreate(data) {
  var comments = '#' + data.table + '-' + data.commentable_id + ' .comments '
  if (data.errors && data.user_id === gon.user_id) {
    $(comments + '.errors').html(require("../packs/templates/shared/_errors.handlebars")({ resource: data }))
  } else if (!data.errors) {
    if (data.user_id == gon.user_id) {
      data.user_eq_current_user = true
    }
    $(comments + '.errors').html('')
    $(comments + '.new form div textarea').val('')
    $(comments + '.list').append(require("../packs/templates/comments/_comment.handlebars")({ comment: data }))
  }
}

function commentsController(data) {
  if (data.action === 'destroy') commentsControllerDestroy(data)
}

function commentsControllerDestroy(data) {
  $('.comments-' + data.id).remove()
}
