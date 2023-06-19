import consumer from "./consumer"

consumer.subscriptions.create("QuestionsIndexChannel", {
  connected() {
    if (!document.querySelector('.page-mark.questions-index-js')) return

    this.perform('questions_index_follow')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.questions-headers-list').append(data)
  }
});
