//import express from 'express';
//import { Request, Response } from "express";
import express, { Request, Response } from 'express';
import * as bodyParser from "body-parser"
import { FutureMatch } from "../entity/FutureMatches"
import { Matches } from "../entity/Matches"
import { Posts } from "../entity/Posts"
import { Videos } from "../entity/Videos"
import { Comments } from "../entity/Comments"
import { url } from 'inspector';
import { privateEncrypt } from 'crypto';
import { readFileSync } from 'fs';
import { Events } from '../entity/Events';
import { sseRoutes } from "./sseRoutes";
import axios, { AxiosRequestConfig } from 'axios';
const router = express.Router();

var jsonParser = bodyParser.json()
router.get("/", async (req: Request, res: Response) => {
    
})


router.post("/posts", async (req: Request, res: Response) => {
    console.log("Request accepted - Posts")
    for (var x of req.body.posts) {
        let find = await Posts.findOne({where: {title: x.title}/*, order: {created_date: "ASC"}*/})
        if (find == null) {
            console.log(x)
            const add_post = Posts.create({
                date: x.date,
                title: x.title,
                text: x.text,
                tag: x.tag,
                image_url: x.image_url,
                url: x.url
            })
            await add_post.save()
        }
        else {
            continue
        }

    }
    res.status(200).json({ "status": true, "result": 'Successful!' })
    //console.log("Complete")
})


router.post("/videos", async (req: Request, res: Response) => {
    console.log("Request accepted - Videos")
    //  console.log(req.body.videos)
    for (var x of req.body.videos) {
        let find = await Videos.findOne({where: {videoID: x.videoId}})
        if (find == null) {
            const add_video = Videos.create({
                videoID: x.videoId,
                thumbnail: x.thumbnail,
                title: x.title,
                description: x.description,
                publishedTime: x.publishedTime,
                lengthVideo: x.lengthVideo,
                viewCount: x.viewCount
            })
            //console.log(add_video)
            //console.log(x.title)
            await add_video.save()
        }
        else {
            continue
        }
    }
    res.status(200).json({ "status": true, "result": 'Successful!' })
})

router.post("/comments", async (req: Request, res: Response) => {  
    var fix_id = req.body.fixture_id
    for (var x of req.body.comments) {
        const add_comment = await Comments.create({
            fixture_id: fix_id,
            time: x.time,
            description: x.text,
            type: x.type
        })
        await add_comment.save()
    }
    if (req.body.past_match == "false") {
        const response = await axios.post('http://slavia-api:8000/stream/pushdata', {type: 'update'});
    }
    res.status(200).json({ "status": true, "result": 'Successful!' })
    console.log("Complete - Comments Scrap")
})

router.post("/test", async (req: Request, res: Response) => {
    let body = req.body
    let response = await Matches.find({
        order: {raw_date: "ASC"}
    })
    res.status(200).json({ "response": response, "result": 'Successful!' })
    console.log("Complete")
})

/*router.get("/delete", async (req: Request, res: Response) => {
    await Posts.delete({title: "Setkání kapitánů před duelem s Plzní"})
    await Posts.delete({title: "Diana Bartovičová prodloužila smlouvu do roku 2026"})
    //await Posts.delete({title: "Lístky na Olomouc jsou v prodeji"})
    //await Posts.delete({title: "O nedostatku pohybu, psychice i inkasované brance"})
    //await Posts.delete({title: "Umíme hrát líp. Najdeme ideální mix"})
    res.status(200).json({ "result": 'Successful!' })
    console.log("Complete Delete")
})*/
/*router.get("/test", async (req: Request, res: Response) => {
    interface dataType {
        key: number;
        asset: string;
        owner: string;
        value: string;
      }
    var aha: dataType = {key: 2, asset: "ahoj", owner: "kdo asi", value: "moc"} 
    var moc  = [aha,aha,aha,aha,aha,aha,aha,aha,aha,aha,aha,aha,aha,aha]
    const add_match = Matches.create({
        fixture_id: 78556,
        type: 1,
        date: 
            {year: 20, month: 20, day: 25},
        time: 
            {hour: 20, minutes: 20,second: 20},
        place: "test",
        city: "test",
        league: "test",
        round: "test",
        status_short: "test",
        status_long: "test",
        elapsed: "test",
        home_team:
            {id: 99, name: "test", logo: "test"},
        
        away_team:
            {id: 77, name: "test", logo: "test"},
        list: moc
    })
    add_match.save()
    res.status(200).json({ "result": 'Successful!' })
    console.log("Complete Delete")
})*/








export { router as additionalRoutes }