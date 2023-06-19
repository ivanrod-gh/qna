document.addEventListener('turbolinks:load', function() {
  if (!document.querySelector('.page-mark.questions-show-js')) return

  document.querySelector('.question').addEventListener('click', showQuestionEditForm)
})

function showQuestionEditForm(event) {
  if (event.target.className != "edit-question-link") return

  event.preventDefault()
  event.target.classList.add('hide')
  document.querySelector('#edit-question').classList.remove('hide')
}
