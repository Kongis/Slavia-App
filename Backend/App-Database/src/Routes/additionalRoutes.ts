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
const router = express.Router();

var jsonParser = bodyParser.json()
router.get("/", async (req: Request, res: Response) => {
    
})


router.post("/posts", async (req: Request, res: Response) => {
    //let x = req.body.message
    //console.log(req.body)
    console.log("Request accepted - Posts")
    for (var x of req.body.posts) {
        let find = await Posts.findOne({where: {title: x.title}})
        if (find == null) {
            const add_post = Posts.create({
                date: x.date,
                title: x.title,
                text: x.text,
                tag: x.tag,
                image_url: x.image_url,
                url: x.url
            })
            add_post.save()
        }
        else {
            //console.log("This already in database - Posts")
            continue
        }
        //@ts-ignore
        //console.log(x.tag)

    }
    res.status(200).json({ "status": true, "result": 'Successful!' })
    //console.log("Complete")
})


router.post("/videos", async (req: Request, res: Response) => {
    console.log("Request accepted - Videos")
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
            add_video.save()
        }
        else {
            //console.log("This already in database - Videos")
            continue
        }
    }
    res.status(200).json({ "status": true, "result": 'Successful!' })
})


router.post("/comments", async (req: Request, res: Response) => {
    for (var x of req.body.comments) {
        const add_comment = Comments.create({
            time: x.time,
            description: x.text
        })
        add_comment.save()
    }
    res.status(200).json({ "status": true, "result": 'Successful!' })
    console.log("Complete")
})









export { router as additionalRoutes }