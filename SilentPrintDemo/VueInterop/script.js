var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!',
    seen: true,
    todos: [
            { text: 'Learn JavaScript' },
            { text: 'Learn Vue' },
            { text: 'Build something awesome' }
            ],
    logophoto: 'imageIcon.png'

  },
    methods: {
      openCameraRoll: function () {
        var message = {"action":"openCameraRoll"}
        window.webkit.messageHandlers.interOp.postMessage(message)
      }
    }
})

function changeLogo(path) {
  app.logophoto = path
}
