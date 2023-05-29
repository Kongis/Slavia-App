//import express from 'express';
//import { Request, Response } from "express";
import express, { Request, Response } from 'express';
import * as bodyParser from "body-parser"
import { FutureMatch } from "../entity/FutureMatches"
import { Matches } from "../entity/Matches"
import { Events } from "../entity/Events"
import { MoreThan } from 'typeorm';
import { Posts } from '../entity/Posts';
import { Videos } from "../entity/Videos"
import { Comments } from '../entity/Comments';
const router = express.Router();




router.post("/getmatches", async (req: Request, res: Response) => {
    let body = req.body
    console.log(body, "Matches")
    let response = []
    let find = await Matches.find({where: {updated_date: MoreThan(new Date(body.last_updated))}, order: {raw_date: "DESC"}})//await Matches.findOne({where: {fixture_id: 962767}})
    for (var x of find) {
        let events = await Events.find({where: {fixture_id: x.fixture_id}})
        let comments = await Comments.find({where: {fixture_id: x.fixture_id}})
        events.sort((a,b) => a.event.time - b.event.time)
        let complete = {
            "match": x,
            "events": events,
            "comments": comments
        }
        response.push(complete)
    }
    /*let events = await Events.find({where: {fixture_id: find.fixture_id}})
        let complete = {
            "match": find,
            "events": events
        }
        response.push(complete)
    events.sort((a,b) => a.event.time - b.event.time)
    console.log(response)*/
    //console.log(response.length)
    res.status(200).json({ "response": response, "result": 'Successful!' })
})

router.post("/getfuturematches", async (req: Request, res: Response) => {

    let body = req.body
    console.log(body,    "Future Matches")
    let response = await FutureMatch.find({where: {updated_date: MoreThan(new Date(body.last_updated))}, order: {raw_date: "ASC"}}) //Maybe DESC  //await Matches.findOne({where: {fixture_id: 962767}})
    /*let events = await Events.find({where: {fixture_id: find.fixture_id}})
        let complete = {
            "match": find,
            "events": events
        }
        response.push(complete)
    events.sort((a,b) => a.event.time - b.event.time)
    console.log(response)*/
    //console.log(response.length)
    res.status(200).json({ "response": response, "result": 'Successful!' })
})

router.post("/getposts", async (req: Request, res: Response) => {

    let body = req.body
    console.log(body,    "Posts")
    let response = await Posts.find({where: {created_date: MoreThan(new Date(body.last_updated))}, order: {created_date: "DESC"}})//await Matches.findOne({where: {fixture_id: 962767}})
    /*let events = await Events.find({where: {fixture_id: find.fixture_id}})
        let complete = {
            "match": find,
            "events": events
        }
        response.push(complete)
    events.sort((a,b) => a.event.time - b.event.time)
    console.log(response)*/
    //console.log(response.length)
    res.status(200).json({ "response": response, "result": 'Successful!' })
})

router.get("/getvideos", async (req: Request, res: Response) => {
    console.log("Videos")
    let response = await Videos.find({order: {created_date: "DESC"}})//await Matches.findOne({where: {fixture_id: 962767}})
    /*let events = await Events.find({where: {fixture_id: find.fixture_id}})
        let complete = {
            "match": find,
            "events": events
        }
        response.push(complete)
    events.sort((a,b) => a.event.time - b.event.time)
    console.log(response)*/
    res.status(200).json({ "response": response, "result": 'Successful!' })
})


router.get("/postmatches", async (req: Request, res: Response) => {
    let {} = req.body
    
})

router.get("/futurematches", async (req: Request, res: Response) => {
    let {fixture, date, place, league, round } = req.body
    
})

/*router.post("/futurematches", async (req: Request, res: Response) => {
    let {fixture, date, place, league, round } = req.body
    
})*/








export { router as appRoutes }