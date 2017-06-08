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
    logophoto: 'imageIcon.png',
    photo2: 'imageIcon.png'

  },
    methods: {
      openCameraRoll: function (photoid) {
        var message = {"action":"openCameraRoll", "photoid": photoid}
        window.webkit.messageHandlers.interOp.postMessage(message)
      },

      enterText: function(textid) {
        alert(textid)
      }
    }
})

function changePhoto(path, photoid) {  
  app[photoid] = path
}
