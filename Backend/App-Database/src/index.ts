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
//import { raw } from 'body-parser';
import { lookup } from 'dns';
import { Twilio } from 'twilio';
import { additionalRoutes } from './Routes/additionalRoutes';
const { HOST, PORT } = require('../config.json');
const { spawn } = require('child_process');



const accountSid = "ACdafdb79349f3cfc7667d364e3698fe2f";
const authToken = "510105af3a8fcc92af7ab1420085c0de";
const twilio = require('twilio');
const client = new twilio(accountSid, authToken);


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




function sms_sender(message) {
    client.messages
        .create({
            body: message, //420739522034
            to: '+420704267909',//'+420704267909', // Text this number
            from: '+17088093326', // From a valid Twilio number
        })
        .then((message) => console.log(message.sid));
}
function future_match() {
    const parameter_league_Url = "fixtures?league="
    const parameterUrl = "&season=2022&team=560&from=" //Sparta 628 , Slavia 560, Olomouc 2250
    const endUrl =  "&to=2023-08-29&timezone=Europe/Prague"
    const leagues = ["345", "347"] //add new league id
    const today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    console.log(yyyy + '-' + mm + '-' + dd)
    for (var x of leagues) {
        const url = baseUrl + parameter_league_Url + x + parameterUrl + yyyy + '-' + mm + '-' + dd + endUrl 
        axios.get(url ,{headers: headers},)
            .then(async (response) => {
                const res = response.data.response
                for (var x of res) {
                    let id = x.fixture.id
                    let raw_date = x.fixture.date
                    let date1 = raw_date.slice(0, -6)
                    let [dateComponents, timeComponents] = date1.split('T');
                    let [year, month, day] = dateComponents.split("-")
                    let [hour, minutes, second] = timeComponents.split(":")
                    let league = x.league.name
                    if (league == "Czech Liga"){
                        league = "Fortuna Liga"
                    }
                    if (league == "Cup"){
                        league = "Mol Cup"
                    }
                    let found = await FutureMatch.findOne({where: {fixture_id: x.fixture.id}})
                    let equal_status = await FutureMatch.findOne({where: {fixture_id: x.fixture.id, status: x.fixture.status.short}})
                    if (found == null) {
                        const add_future_match = FutureMatch.create({
                        fixture_id: x.fixture.id,
                        date: 
                            {year: year, month: month, day: day},
                        time: 
                            {hour: hour, minutes: minutes,second: second},
                        place: x.fixture.venue.name,
                        city: x.fixture.venue.city,
                        league: league,
                        round: x.league.round,
                        status: x.fixture.status.short,
                        home_team: 
                            {id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo},

                        away_team:
                            {id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo},
                        
                        /*team_slavia: 
                            {id: slavia_team_id, name: slavia_team_name, logo: slavia_team_logo},
                        team_other:
                            {id: other_team_id, name: other_team_name, logo: other_team_logo},*/
                        })
                        add_future_match.save()/*,
                        //console.log("Added")*/
                    }
                    else {
                        if (found.status != x.fixture.status.short) {
                        await FutureMatch.update({
                            fixture_id: id,
                            }, {
                                status: x.fixture.status.short,
                                date: 
                                    {year: year, month: month, day: day},
                                time: 
                                    {hour: hour, minutes: minutes,second: second},
                            }
                            )
                        }
                    }
                    
                }
                //console.log(res.fixture, res.league, res.teams)
            })
            .catch((error) => {
                console.log(error.response.statusText, "  Error code:", error.response.status)
            })
    }
    console.log("Finish")
    return
}

function past_matches() {
    const parameter_league_Url = "fixtures?league="
    const parameterUrl = "&season=2022&team=560&from=" //Sparta 628 , Slavia 560, Olomouc 2250
    //const toUrl = ""
    //const endUrl =  "&to="+yyyy+"-"+mm+"-"+dd+"&timezone=Europe/Prague"
    const leagues = ["345", "347"] //add new league id
    const today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    const endUrl =  "&to="+yyyy+"-"+mm+"-"+dd+"&timezone=Europe/Prague"
    //console.log(yyyy + '-' + mm + '-' + dd)
    for (var x of leagues) {
        console.log("League id is: " + x)
        const url = baseUrl + parameter_league_Url + x + parameterUrl + "2022" + '-' + "01" + '-' + "01" + endUrl //yyyy + '-' + mm + '-' + dd + endUrl 
        axios.get(url ,{headers: headers})
            .then(async (response) => {
                //console.log(url)
                const res = response.data.response
                for (var y of res) {
                    let id = y.fixture.id
                    let raw_date = y.fixture.date
                    let date1 = raw_date.slice(0, -6)
                    let [dateComponents, timeComponents] = date1.split('T');
                    let [year, month, day] = dateComponents.split("-")
                    let [hour, minutes, second] = timeComponents.split(":")
                    let league = y.league.name
                    if (league == "Czech Liga"){
                        league = "Fortuna Liga"
                    }
                    if (league == "Cup"){
                        league = "Mol Cup"
                    }
                    const add_past_match = await Matches.create({
                        fixture_id: y.fixture.id,
                        date: 
                            {year: year, month: month, day: day},
                        time: 
                            {hour: hour, minutes: minutes,second: second},
                        place: y.fixture.venue.name,
                        city: y.fixture.venue.city,
                        league: league,
                        round: y.league.round,
                        status: y.fixture.status.short,
                        home_team: 
                            {id: y.teams.home.id, name: y.teams.home.name, logo: y.teams.home.logo, goals: y.goals.home},

                        away_team:
                            {id: y.teams.away.id, name: y.teams.away.name, logo: y.teams.away.logo, goals: y.goals.away},
                    })
                    add_past_match.save()
                    console.log("Past Matches with id: " + id + " is Saved")
                    const eventUrl = baseUrl + "fixtures/events?fixture=" + id
                    await axios.get(eventUrl, {headers: headers})
                        .then(async (response) => {
                            const res = response.data.response
                            for (var z of res) {
                                let assist = z.assist.name
                                let type = z.detail
                                let type_short = z.type
                                //type = type.slice(0, -2)
                                if (type_short == "subst") {
                                    type = "Střídání"
                                }
                                if (type_short == "Card") {
                                    type = type.slice(0, -5)
                                    if (type == "Yellow"){
                                        type = "Žlutá karta"
                                    }
                                    if (type == "Red"){
                                        type = "Červená karta"
                                    }
                                }
                                if (type_short == "Goal") {
                                    type = "Góóól"
                                }
                                if (assist == null) {
                                    assist = ""
                                }
                                const add_event = Events.create({
                                    fixture_id: id,
                                    event: 
                                        {time: z.time.elapsed, team: z.team.id, player: z.player.name, assist: assist, type: type}
                                })
                                add_event.save()
                                
                            }
                            console.log("Events for match: " + id + " is Saved")
            
                    })
                }
                return
                //console.log(res)
            })
            .catch(err => {
                console.log(err);
            });

        /*axios.get(url2, {headers})
        .then(async (response) => {
            const res = response.data.response
            console.log(res)
        })*/
    }
    return;
}


const live_match = async (h, m, fix_id, search_data) =>  {
    console.log("Live Match")
    let search = "isport blesk fotbal "+ search_data + " online"  
    let start_hour = Number(h)
    let start_minutes = Number(m)
    let live = false
    let events_index = 0
    const url = baseUrl + "fixtures?id=" + fix_id + "&timezone=Europe/Prague"
    axios.get(url ,{headers: headers})
        .then(async (response) => {
            const x = response.data.response[0]
            let raw_date = x.fixture.date.slice(0, -6)
            //let date = raw_date.slice(0, -6)
            let [dateComponents, timeComponents] = raw_date.split('T');
            let [year, month, day] = dateComponents.split("-")
            let [hour, minutes, second] = timeComponents.split(":")
            let league = x.league.name
            if (league == "Czech Liga"){
                league = "Fortuna Liga"
            }
            if (league == "Cup"){
                league = "Mol Cup"
            }
            const add_match = Matches.create({
                fixture_id: x.fixture.id,
                date: 
                    {year: year, month: month, day: day},
                time: 
                    {hour: hour, minutes: minutes,second: second},
                place: x.fixture.venue.name,
                city: x.fixture.venue.city,
                league: league,
                round: x.league.round,
                status: x.fixture.status.short,
                home_team:
                    {id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo},
                
                away_team:
                    {id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo},
            })
            add_match.save()   
        })
        .catch((error) => {
            console.log(error.response.statusText, "  Error code:", error.response.status)
        })
    while (live == false) {
        //console.log("While")
        let today = new Date();
        let now_hour/*hot*/ = Number(String(today.getHours() + 1).padStart(2, "0"));
        let now_minutes/*min*/ = Number(String(today.getMinutes()).padStart(2, "0"));
        //var now_hour = Number(hot)
        //var now_minutes = Number(min)
        //var time = String(ho) + String(mi)
        //console.log(ho, mi,  time)
        if (now_hour == start_hour && now_minutes > start_minutes) {
            let mes = "Zápas začíná"
            console.log("Match starting") 
            sms_sender(mes)
            live = true
        }
        else {
            let hours = [5, 4, 3, 2, 1]
            for (var x of hours) {
                if (now_hour == (start_hour - x) && now_minutes == 0) {
                    let msg = "Zápás začíná za" + String(x) + "hodina"
                    console.log(msg)
                    break
                }
                else {
                    continue
                } 
            }
            await sleep(60000) //10000 ms - 10s
            }
        }
    while (live == true) {
        const parameterUrl_events = "fixtures/events?fixture="
        const parameterUrl = "fixtures?id="
        const url = baseUrl + parameterUrl + fix_id + "&timezone=Europe/Prague"
        const url_events = baseUrl + parameterUrl_events + fix_id
        const child = spawn('python', ['src/Python/data_scraping/spiders/comments-scrap.py', search]);
        axios.get(url ,{headers: headers})
            .then(  async (response) => {
                let x = response.data.response[0]
                console.log(x)                // Index of Events object 
                // If Events.lenght < y
                // y = index of x
                let found = await Matches.findOne({where: {fixture_id: fix_id}})
                if  (x.goals.home != found.home_team.goals || x.goals.away != found.away_team.goals || x.fixture.status.short != found.status) {
                    Matches.update({
                        fixture_id: fix_id
                    }, {
                        home_team:
                            {goals: x.goals.home},
                        away_team: 
                            {goals: x.goals.away},
                        status: x.fixture.status.short
                    })

                }
                if (x.fixture.status.short == "FM") {
                    console.log("Konec zápasu")
                    await sleep(300000)
                    child.kill('SIGTERM');
                    return
                }
            })
            .catch((error) => {
                console.log(error.response.statusText, "  Error code:", error.response.status)
            })
        axios.get(url_events ,{headers: headers})
            .then(async (response) => {                 //Maybe change response name
                let res = response.data.response
                let current_index = res.length
                if (current_index == events_index) {
                    await sleep(180000) //2000
                }
                else {
                    let max_length = res.length + 1
                    let array = res.slice(current_index, max_length)
                    for (var x of array) {
                            let assist = x.assist.name
                            let type = x.detail
                            let type_short = x.type
                            //type = type.slice(0, -2)
                            if (type_short == "subst") {
                                type = "Střídání"
                            }
                            if (type_short == "Card") {
                                type = type.slice(0, -5)
                                if (type == "Yellow"){
                                    type = "Žlutá karta"
                                }
                                if (type == "Red"){
                                    type = "Červená karta"
                                }
                            }
                            if (type_short == "Goal") {
                                type = "Góóól"
                            }
                            if (assist == null) {
                                assist = ""
                            }
                            const add_event = await Events.create({
                                fixture_id: fix_id,
                                event: 
                                {time: x.time.elapsed, team: x.team.id, player: x.player.name, assist: assist, type: type}
                            })
                            add_event.save()
                    }
                    events_index = current_index
                    await sleep(180000) //2000
                }
            })
            .catch((error) => {
                console.log(error.response.statusText, "  Error code:", error.response.status)
            })
    }
}



const match_checker = async () => {
    
    let today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = String(today.getFullYear());
    let now = yyyy + '/' + mm + '/' + dd
    let found = await AppDataSource
        .getRepository(FutureMatch)
        .createQueryBuilder("future")
        .select()
        .where('future.date ::jsonb @> :date', {
            date: {
                year: yyyy, 
                month: mm,
                day: dd,
            }
        })
        .getOne()
    if (found == null) {
        console.log("Dnes se nekoná žádný zápas Slavie")
        return null
    }
    else {
        let start_id = String(found.fixture_id)
        let start_hour = found.time.hour 
        let start_minute = found.time.minutes
        let message = "Dnes začíná zápas:" + " " + found.home_team.name + " - " + found.away_team.name + "  " + String(start_hour) + ":" + String(start_minute)
        let search_data = String(found.home_team.name) + " " + String(found.away_team.name) + " " + String(found.date.day) +  "." + String(found.date.month) + " " + String(found.date.year)
        sms_sender(message)
        live_match(start_hour, start_minute, start_id, search_data)
        return
        }
}

function get_post() {
    const child = spawn('python', ['src/Python/data_scraping/spiders/post-scrap.py']);
}

const main = async () => {
    const day = 86400000;
    await future_match()
    await match_checker()
    await get_post()
    await setInterval(() => {
        future_match();
    }, day);
    console.log("Function Future_Match has ended")
    await setInterval(() => {
        match_checker();
    }, day);
    console.log("Function Match_Checker has ended")
    await setInterval(() => {
        get_post();
    }, day);
    console.log("Function Get_Post has ended") 
}   
AppDataSource.initialize().then(() => {
    app.listen(PORT, HOST, () => {
        console.log(`Web App listening at http://${HOST}:${PORT}`)
        //const { spawn } = require('child_process');
        //const child = spawn('python', ['src/Python/data_scraping/spiders/post-scrap.py']); //src/Python/url_scraping/url_scrap.py
        //onst child1 = spawn('python', ['src/Python/url_scraping/url_scrap.py']);
        //main() 
        //future_match()
        //past_matches()   
        console.log("Function past_matches dont starting because I have free plan on api services")
    });
    
})