function handler(event) {
    console.log(JSON.stringify(event))
    var request = event.request;
    var host = request.headers.host;
    var accept = request.headers.accept;

    if (accept
        && accept.length
        && accept[0].value.includes("/html")
        && !(request.uri.endsWith("/") || request.uri.endsWith(".html"))
    ) {
        request.uri += "/";
    }

    if (host && host.value) {
        var h = host.value
        var pr_id = h.substring(0, h.lastIndexOf('-preview'));
        if (pr_id) {
            request.uri = `/${pr_id}${request.uri}`;
            return request;
        }
    }

    // Response when JWT is not valid.
    return {
        statusCode: 401,
        statusDescription: 'Missing Host header'
    };
}
