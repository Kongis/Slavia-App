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
import { ForumPost } from '../entity/ForumPost';
import { ForumComment } from '../entity/ForumComment';
const router = express.Router();

var jsonParser = bodyParser.json()
router.post("/posts", async (req: Request, res: Response) => {
    let body = req.body
    let type = body.type
    let take = Number(body.to) - Number(body.from)
    let response = await ForumPost.find({skip: Number(body.from), take: take})
    res.status(200).json({ "response": response, "result": 'Successful!' })
})  


router.post("/comment", async (req: Request, res: Response) => {
    let body = req.body
    let response = await ForumComment.find({where: {parent_id: body.parent_id}})
    res.status(200).json({ "response": response, "result": 'Successful!' })
}) 


router.post("/create_post", async (req: Request, res: Response) => {
    let body = req.body
    let save =  await ForumPost.create({
        user_id: body.user_id,
        username: body.username,
        title: body.title,
        text: body.text,
        tag: body.tag
    })
    save.save()
    res.status(200).json({"result": 'Successful!' })
})  

router.post("/create_comment", async (req: Request, res: Response) => {
    let body = req.body
    let save = await ForumComment.create({
        user_id: body.user_id,
        username: body.username,
        text: body.text,
        parent_id: body.parent_id,
        //post_id: body.post_id,

    })
    save.save()
    if (body.parent_id == body.post_id) {
        await ForumPost.update({
            id: body.post_id
        },{
            child_count: () => 'child_count + 1'
        }
        )
    }
    else {
        await ForumPost.update({
            id: body.post_id
        },{
            child_count: () => 'child_count + 1'
        }
        )
        await ForumComment.update({
            id: body.parent_id
        },{
            child_count: () => 'child_count + 1'
        }
        )
    }
    /*let post = await ForumPost.findOne({where: {id: body.post_id}})
    await ForumPost.update(
        {
            id: body.post_id
        },{
            child_count: post.child_count ++
        }
    )*/
    //let response
    res.status(200).json({"result": 'Successful!' })
}) 



export { router as forumRoutes }