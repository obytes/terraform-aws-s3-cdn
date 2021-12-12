function pointsToFile(uri) {return /\/[^/]+\.[^/]+$/.test(uri);}
function hasTrailingSlash(uri) {return uri.endsWith("/");}
function needsTrailingSlash(uri) {return !pointsToFile(uri) && !hasTrailingSlash(uri);}
function previewPRId(host) {
    if (host && host.value) {
        return host.value.substring(0, host.value.lastIndexOf('-preview'));
    }
}

function objectToQueryString(obj) {
    var str = [];
    for (var param in obj)
        if (obj[param].multiValue)
            str.push(param + "=" + obj[param].multiValue.map((item) => item.value).join(','));
        else if (obj[param].value === '')
            str.push(param);
        else
            str.push(param + "=" + obj[param].value);

    return str.join("&");
}

function handler(event) {
    console.log(JSON.stringify(event))
    var request = event.request;
    var host = request.headers.host;

    // Extract the original URI and Query String from the request.
    var original_uri = request.uri;
    var qs = request.querystring;

    // If needed, redirect to the same URI with trailing slash, preserving query string.
    if (needsTrailingSlash(original_uri)) {
        console.log(`${original_uri} needs trailing slash, redirect!`);
        return {
            statusCode: 302,
            statusDescription: "Moved Temporarily",
            headers: {
                location: { "value": Object.keys(qs).length ? `${original_uri}/?${objectToQueryString(qs)}` : `${original_uri}/`}
            }
        };
    }

    // Match any '/' that occurs at the end of a URI, replace it with a default index
    // Useful for single page applications or statically generated websites that are hosted in an Amazon S3 bucket.
    var new_uri = original_uri.replace(/\/$/, '\/index.html');

    var pr_id = previewPRId(host);
    if (pr_id) {
        // Re-write the url to the target preview S3 Key
        request.uri = `/${pr_id}${new_uri}`;
    }
    else {
        // Replace the received URI with the URI that includes the index page
        request.uri = new_uri;
    }

    console.log(`Original URI: ${original_uri}`);
    console.log(`New URI: ${new_uri}`);
    return request;
}
