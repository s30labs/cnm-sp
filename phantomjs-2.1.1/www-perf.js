"use strict";
if (!Date.prototype.toISOString) {
    Date.prototype.toISOString = function () {
        function pad(n) { return n < 10 ? '0' + n : n; }
        function ms(n) { return n < 10 ? '00'+ n : n < 100 ? '0' + n : n }
        return this.getFullYear() + '-' +
            pad(this.getMonth() + 1) + '-' +
            pad(this.getDate()) + 'T' +
            pad(this.getHours()) + ':' +
            pad(this.getMinutes()) + ':' +
            pad(this.getSeconds()) + '.' +
            ms(this.getMilliseconds()) + 'Z';
    }
}

function createHAR(address, title, startTime, resources)
{
    var entries = [];

    resources.forEach(function (resource) {
        var request = resource.request,
            startReply = resource.startReply,
            endReply = resource.endReply;

        if (!request || !startReply || !endReply) {
            return;
        }

        // Exclude Data URI from HAR file because
        // they aren't included in specification
        if (request.url.match(/(^data:image\/.*)/i)) {
            return;
	}

        entries.push({
            startedDateTime: request.time.toISOString(),
            time: endReply.time - request.time,
            request: {
                method: request.method,
                url: request.url,
                httpVersion: "HTTP/1.1",
                cookies: [],
                headers: request.headers,
                queryString: [],
                headersSize: -1,
                bodySize: -1
            },
            response: {
                status: endReply.status,
                statusText: endReply.statusText,
                httpVersion: "HTTP/1.1",
                cookies: [],
                headers: endReply.headers,
                redirectURL: "",
                headersSize: -1,
                bodySize: startReply.bodySize,
                content: {
                    size: startReply.bodySize,
                    mimeType: endReply.contentType
                }
            },
            cache: {},
            timings: {
                blocked: 0,
                dns: -1,
                connect: -1,
                send: 0,
                wait: startReply.time - request.time,
                receive: endReply.time - startReply.time,
                ssl: -1
            },
            pageref: address
        });
    });

    return {
        log: {
            version: '1.2',
            creator: {
                name: "PhantomJS",
                version: phantom.version.major + '.' + phantom.version.minor +
                    '.' + phantom.version.patch
            },
            pages: [{
                startedDateTime: startTime.toISOString(),
                id: address,
                title: title,
                pageTimings: {
                    onLoad: page.endTime - page.startTime
                }
            }],
            entries: entries
        }
    };
}

var page = require('webpage').create(),
    system = require('system'),
    execFile = require("child_process").execFile,
    fs = require('fs'),
    id='',dir='/opt/data/extra_data',
    error='';

if (system.args.length === 1) {
    console.log('Usage: netsniff.js <some URL> [filename] [dir]');
    phantom.exit(1);
} else {

    page.settings.userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11";

    page.viewportSize = {
        width: 1280,
        height: 800
    };
    page.zoomFactor = 1; 

    page.address = system.args[1];

    if (system.args.length > 2) {
		  id = system.args[2];
    }
    if (system.args.length == 4) {
        dir = system.args[3];
    }


    page.resources = [];

    page.onLoadStarted = function () {
        page.startTime = new Date();
    };

    page.onResourceRequested = function (req) {
        page.resources[req.id] = {
            request: req,
            startReply: null,
            endReply: null
        };
    };

    page.onResourceReceived = function (res) {
        if (res.stage === 'start') {
            page.resources[res.id].startReply = res;
        }
        if (res.stage === 'end') {
            page.resources[res.id].endReply = res;
        }
        error=res;
    };

    // En caso de existir el fichero har.gz previamente creado, se lee
    if(id!='' && fs.exists(dir+'/'+id+'.har.gz')){

        execFile("zcat", [dir+'/'+id+'.har.gz'], null, function (err, stdout, stderr) {
            console.log(stdout)
            console.log(stderr)
            phantom.exit();
        })
    }
    // En caso de existir el fichero har previamente creado, se lee
    else if(id!='' && fs.exists(dir+'/'+id+'.har')){

        execFile("cat", [dir+'/'+id+'.har'], null, function (err, stdout, stderr) {
            console.log(stdout)
            console.log(stderr)
            phantom.exit();
        });
    }
    // En caso de no existir un fichero previo se sigue el funcionamiento normal
    else{

        page.open(page.address, function (status) {
            var har;
            if (status !== 'success') {
                // console.log('FAIL to load the address');
                console.log(JSON.stringify(error, undefined, 4));
    				if(id!=''){
    					var page_error = require('webpage').create();
    					page_error.viewportSize = {
    						width: 680,
    						height: 500
    					};
    					page_error.content = '<html style="    font-size: 125%;direction: ltr; unicode-bidi: isolate;-webkit-locale: en;    display: block;"><body style="font-family: sans, Arial, sans-serif; font-size: 75%;background-color: #f7f7f7;color: #646464;    display: block; margin: 8px;"><div><h1 style="font-family: sans, Arial, sans-serif;margin: 0 0 15px;word-wrap: break-word;color: #333;font-size: 1.6em;font-weight: normal;line-height: 1.25em;margin-bottom: 16px;display: block;-webkit-margin-before: 0.67em;-webkit-margin-after: 0.67em;-webkit-margin-start: 0px;-webkit-margin-end: 0px;">The '+page.address+' page isn’t working</h1><p style="    display: inline;-webkit-margin-before: 1em; -webkit-margin-after: 1em; -webkit-margin-start: 0px; -webkit-margin-end: 0px;    font-size: 1em; line-height: 1.6em;font-family: sans, Arial, sans-serif;color: #646464;"><strong>'+page.address+'</strong> is currently unable to handle this request.</p><div style="font-size: .8em;display: block;color: #696969;margin-top: 10px;opacity: .5;text-transform: uppercase;line-height: 1.6em;    font-family: sans, Arial, sans-serif;">HTTP ERROR '+error.status+' : '+error.statusText+'</div></div></body></html>';
    					// page_error.render(dir+'/'+id+'.png');
                  page_error.render(dir+'/'+id+'.jpeg', {format: 'jpeg', quality: '50'});
    					fs.write(dir+'/'+id+'.har', JSON.stringify(error, undefined, 4), 'w');
    
    					execFile("gzip", [dir+'/'+id+'.har'], null, function (err, stdout, stderr) {
    						console.log("execFileSTDOUT:", JSON.stringify(stdout))
    						console.log("execFileSTDERR:", JSON.stringify(stderr))
    					})
    
    				}
                phantom.exit(1);
            } else {
                page.endTime = new Date();
                page.title = page.evaluate(function () {
                    return document.title;
                });
                har = createHAR(page.address, page.title, page.startTime, page.resources);
                console.log(JSON.stringify(har, undefined, 4));
    				if(id!=''){
    					// page.render(dir+'/'+id+'.png');
                  page.render(dir+'/'+id+'.jpeg', {format: 'jpeg', quality: '50'});

    					fs.write(dir+'/'+id+'.har', JSON.stringify(har, undefined, 4), 'w');
    
                    execFile("gzip", [dir+'/'+id+'.har'], null, function (err, stdout, stderr) {
                      console.log("execFileSTDOUT:", JSON.stringify(stdout))
                      console.log("execFileSTDERR:", JSON.stringify(stderr))
                   })
    
    				}
                phantom.exit();
            }
        });
    }
}
