import express, { Request, Response } from 'express';

import * as bodyParser from "body-parser"
import { FutureMatch } from "../entity/FutureMatches"
import { Matches } from "../entity/Matches"
import { Posts } from "../entity/Posts"
import { Videos } from "../entity/Videos"
import { Comments } from "../entity/Comments"
import { url } from 'inspector';
import { privateEncrypt } from 'crypto';
import {Session, createSession} from "better-sse";
import axios, { AxiosRequestConfig } from 'axios';
import { AxiosResponse, AxiosError } from 'axios'
//const express = require('express')
//import express from 'express';
const router = express.Router();
//var SSE = require('sse')
const http = require('http');
//var SSE = require('express-sse');
//var sse = new SSE(/*["array", "containing", "initial", "content", "(optional)"]*/);
//var jsonParser = bodyParser.json() 
var firstLaunch = true
//router.get("/notification", sse.init);

router.get("/notification", async (req, res) => {
	globalThis.session = await createSession(req, res);
  console.log("SSE register")
  /*router.post("/pushdata", async (req: Request, res: Response) => {
    //console.log("here")
    var message = req.body
    console.log(message)
    await globalThis.session.push(message);
    //await sse.send(message)*/
//})
	//session.push("Hello world!");
});
//const response = axios.get("http://10.143.103.78:8000/stream/notification");


router.post("/pushdata", async (req: Request, res: Response) => {
  //console.log("here")
  console.log(req.socket.remoteAddress)
  if (firstLaunch == true) {
    const config: AxiosRequestConfig = {
      timeout: 2000, // Timeout v milisekundách
    };
    try {
    await axios.get("http://slavia-api:8000/stream/notification", config);
    } catch (error) {

    }
    firstLaunch = false
    var message = req.body
    console.log(message)
    await globalThis.session.push(message);
    //await sse.send(message)
    res.status(200).json({ "status": true, "result": 'Successful!' })
  }
  else {
    var message = req.body
    console.log(message)
    await globalThis.session.push(message);
    //await sse.send(message)
    res.status(200).json({ "status": true, "result": 'Successful!' })
  }
})

/*router.post("/pushdata", async (req: Request, res: Response) => {
    //console.log("here")
    var message = req.body
    console.log(message)
    //await sse.send(message)
    res.status(200).json({ "status": true, "result": 'Successful!' })
})*/


/*function send () {
    console.log("here")
    router.get("/notification", async (req: Request, res: Response) => {
        console.log("Push Notification send")
        res.write("Ahoj")
    })
}*/


/*const server = http.createServer((req, res) => {
    // Server-sent events endpoint
    if (req.url === '/notification') {
      res.writeHead(200, {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        ...(req.httpVersionMajor === 1 && { 'Connection': 'keep-alive' })
      });
  
      const refreshRate = 1000; // in milliseconds
      return setInterval(() => {
        const id = Date.now();
        const data = `Hello World ${id}`;
        const message =
          `retry: ${refreshRate}\nid:${id}\ndata: ${data}\n\n`;
        res.write(message);
      }, refreshRate);
    }
  
    // Client side
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end(`
      <!DOCTYPE html>
      <html lang="en" dir="ltr">
        <head>
          <meta charset="utf-8">
          <title>SSE</title>
        </head>
        <body>
          <pre id="log"></pre>
        </body>
        <script>
          var eventSource = new EventSource('/events');
          eventSource.onmessage = function(event) {
            document.getElementById('log').innerHTML += event.data + '<br>';
          };
        </script>
      </html>
    `);
  });
  
  server.listen(8000);*/

export { router as sseRoutes }

