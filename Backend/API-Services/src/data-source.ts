import "reflect-metadata"
import { DataSource } from "typeorm"
import { FutureMatch } from "./entity/FutureMatches"
import { Matches } from "./entity/Matches"
import { Events } from "./entity/Events";
import { Posts } from "./entity/Posts";
import { Comments } from "./entity/Comments";
import { Videos } from "./entity/Videos";
import { ForumPost } from "./entity/ForumPost";
import { ForumComment } from "./entity/ForumComment";
require('dotenv').config()
export const AppDataSource = new DataSource({
    type: "postgres",
    host: process.env.DB_HOST,
    port: 5432,
    username: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    synchronize: true,
    logging: false,
    entities: [FutureMatch, Matches, Events, Posts, Comments, Videos, ForumPost, ForumComment/*"./entity/*.ts"*/],
    migrations: [],
    subscribers: [],
})


