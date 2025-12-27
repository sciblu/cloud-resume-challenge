// functions/rewrite-index-html.js

function handler(event) {
    var request = event.request;
    var uri = request.uri;
    
    // If URI ends with '/', append 'index.html'
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // If URI doesn't have a file extension, assume it's a directory and add '/index.html'
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }
    
    return request;
}