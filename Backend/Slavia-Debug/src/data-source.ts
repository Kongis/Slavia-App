import "reflect-metadata"
import { DataSource } from "typeorm"
import { FutureMatch } from "./entity/FutureMatches"
import { Matches } from "./entity/Matches"
import { Events } from "./entity/Events";
import { Leagues } from "./entity/Leagues";

export const AppDataSource = new DataSource({
    type: "postgres",
    host: "localhost",
    port: 5432,
    username: "admin",
    password: "gf24f97",
    database: "slavia_db",
    synchronize: true,
    logging: false,
    entities: [FutureMatch, Matches, Events, Leagues/*"./entity/*.ts"*/],
    migrations: [],
    subscribers: [],
})