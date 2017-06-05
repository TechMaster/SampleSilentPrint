var count = 0

function sendCount(){
    var message = {"count":count, "data": "The world is so wild"}
    window.webkit.messageHandlers.interOp.postMessage(message)
}

function storeAndShow(updatedCount){
    document.querySelector("#resultDisplay").innerHTML = 'came back'
    count = updatedCount
    document.querySelector("#resultDisplay").innerHTML = count
    return count
}

function receiveJSON(json) {    
    document.querySelector("#resultDisplay").innerHTML = json.gender;
    alert(json.gender)
}
function doLibCall(){
    //aSillyLibfunc exists in a directory. Some
    var aMessage = aSillyLibFunc()
    document.querySelector("#resultDisplay").innerHTML = aMessage
}
