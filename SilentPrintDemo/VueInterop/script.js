var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!',
    seen: true,
    todos: [
            { text: 'Learn JavaScript' },
            { text: 'Learn Vue' },
            { text: 'Build something awesome' }
            ]
  },
    methods: {
      openCameraRoll: function () {
        window.webkit.messageHandlers.interOp.openCameraRoll()
      }
    }
})
