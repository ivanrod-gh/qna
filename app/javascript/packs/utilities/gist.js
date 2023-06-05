document.addEventListener('turbolinks:load', function() {
  if (!document.querySelector('.page-mark.question-show-js')) return

  document.querySelector('.question-content').addEventListener('click', showGistText)
})

function showGistText(event) {
  if (event.target.className != "show-gist-content") return
  event.preventDefault()

  var gistId = event.target.dataset.gistId
  var linkId = event.target.dataset.linkId

  var { Octokit } = require("@octokit/core")
  var octokit = new Octokit()
  response = octokit.request('GET /gists/' + gistId, {
    gist_id: gistId,
    headers: {
      'X-GitHub-Api-Version': '2022-11-28'
    }
  }).then(result => addGistContentToPage(result, linkId))

 event.target.remove()
}

function addGistContentToPage(result, linkId){
  for (file in result.data.files) {
    var gistContent = "<h3>" + file + "</h3>"
    gistContent = gistContent + "<div>" + result.data.files[file].content + "</div>"
    gistContent = "<div class='gist-file'>" + gistContent + "</div>"
    if (gistContent) {
      $('#link-' + linkId + '-gist-content').append(gistContent)
    }
  }
}
