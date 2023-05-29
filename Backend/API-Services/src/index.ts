import express, { Request, Response } from 'express';
import axios from "axios";
import { AxiosResponse, AxiosError } from 'axios'
//import * as bodyParser from "body-parser"
import bodyParser from "body-parser";
import { AppDataSource } from "./data-source"
import { FutureMatch } from "./entity/FutureMatches"
import { Matches } from "./entity/Matches"
import { Events } from "./entity/Events"
import "reflect-metadata";
import { DataSource, getManager, getRepository, NoNeedToReleaseEntityManagerError } from "typeorm"
import { appRoutes } from "./Routes/appRoutes";
import { sseRoutes } from "./Routes/sseRoutes";
//import { raw } from 'body-parser';
import { lookup } from 'dns';
import { additionalRoutes } from './Routes/additionalRoutes';
import { forumRoutes } from './Routes/forumRoutes';

//const { HOST, PORT } = require('../config.json');
const { spawn } = require('child_process');

const accountSid = "ACdafdb79349f3cfc7667d364e3698fe2f";
const authToken = "510105af3a8fcc92af7ab1420085c0de";


const sleep = (ms) => new Promise(r => setTimeout(r, ms));
const baseUrl = "https://v3.football.api-sports.io/"
let headers = {
    Accept: 'application/json', 'Accept-Encoding': 'identity', 
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "53eab603a7c3ec8222692fb4d3270d5c",
}
const app =  express()
app.use(require('express-status-monitor')());
app.use(express.urlencoded({ extended: false }));
app.use(express.json());
//app.use(bodyParser.urlencoded({extended: true/*false*/}))
//app.use(bodyParser.json({ type: 'application/*+json' }))
//app.use(bodyParser.json());
app.use("/api/app", appRoutes);
app.use("/api/additional", additionalRoutes);
app.use("/stream", sseRoutes)
app.use("/api/forum", forumRoutes)

/*function get_post() {
    const child = spawn('python', ['src/Python/data_scraping/spiders/post-scrap.py']);
}

function get_videos() {
    const child = spawn('python', ['src/Python/url_scraping/url_scrap.py']);
}*/

const main = async () => {
    /*const day = 3600000;
    await get_post()
    await get_videos()
    await setInterval(() => {
        get_post();
    }, day);
    console.log("Function Get_Post has ended") 
    await setInterval(() => {
        get_videos();
    }, day);
    console.log("Function Get_Videos has ended") */
}   
AppDataSource.initialize().then(() => {
    app.listen(8000, () => {
        console.log(`Web App listening at http://${"localhost"}:${8000}`)
        //const { spawn } = require('child_process');
        //const child = spawn('python', ['src/Python/data_scraping/spiders/post-scrap.py']); //src/Python/url_scraping/url_scrap.py
        //onst child1 = spawn('python', ['src/Python/url_scraping/url_scrap.py']);
        //main() 
        //future_match()
        //past_matches()   
        main()
        //console.log("Function past_matches dont starting because I have free plan on api services")
    });
    
})