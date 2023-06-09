document.addEventListener('turbolinks:load', function() {
  if (!document.querySelector('.page-mark.questions-show-js')) return

  document.querySelector('.answers').addEventListener('click', showAnswerEditForm)
})

function showAnswerEditForm(event) {
  if (event.target.className != "edit-answer-link") return

  event.preventDefault()
  event.target.classList.add('hide')
  document.querySelector('#edit-answer-' + event.target.dataset.answerId).classList.remove('hide')
}
