import "reflect-metadata"
import { DataSource } from "typeorm"
import { FutureMatch } from "./entity/FutureMatches"
import { Matches } from "./entity/Matches"
import { Events } from "./entity/Events";
import { Posts } from "./entity/Posts";
import { Comments } from "./entity/Comments";
import { Videos } from "./entity/Videos";

export const AppDataSource = new DataSource({
    type: "postgres",
    host: "localhost",
    port: 5432,
    username: "admin",
    password: "gf24f97",
    database: "slavia_db",
    synchronize: true,
    logging: false,
    entities: [FutureMatch, Matches, Events, Posts, Comments, Videos/*"./entity/*.ts"*/],
    migrations: [],
    subscribers: [],
})


