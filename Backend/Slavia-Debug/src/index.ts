import express, { Request, Response } from 'express';
import axios from "axios";
import { AxiosResponse, AxiosError } from 'axios'
import bodyParser from "body-parser";
import { AppDataSource } from "./data-source"
import { FutureMatch } from "./entity/FutureMatches"
import { Matches } from "./entity/Matches"
import { Events } from "./entity/Events"
import { Leagues } from "./entity/Leagues"
import "reflect-metadata";
//import { DataSource, getManager, getRepository, NoNeedToReleaseEntityManagerError } from "typeorm"
const { HOST, PORT } = require('../config.json');
const { spawn } = require('child_process');
const express = require('express')
const app =  express()
app.use(require('express-status-monitor')());

const sleep = (ms) => new Promise(r => setTimeout(r, ms));
const baseUrl = "https://v3.football.api-sports.io/"
let headers = {
    Accept: 'application/json', 'Accept-Encoding': 'identity', 
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "53eab603a7c3ec8222692fb4d3270d5c",
}
const team_id = "560" //add new league id

const fixtures_status = {
    TBD: "Čas bude definován",
    NS: "Zápas nezačal",
    FH: "První poločas", //1H
    HT: "Poločas", 
    SH: "Druhý poločas", //2H
    ET: "Hra v prodloužení",
    BT: "Přestávka",
    P: "Probíha penalta",
    SUSP: "Zápas pozastaven",
    INT: "Zápas přerušen",
    FT: "Zápas ukončen",
    AET: "Zápas skončil po prodloužení",
    PEN: "Zápas skončil po penaltách",
    PST: "Zápas odložen",
    CANC: "Zápas zrušen",
    ABD: "Zápas odložen z různých důvodů",
    AWD: "Technická ztráta",
    WO: "",
    LIVE: "Právě probíhá",

}

const future_match = async () =>{
    //let raw_leagues = await Leagues.find({where: {team_id: parseInt(team_id)}})
    const leagues = ["345", "347"] //add new league id
    const today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    for (var x of leagues/*raw_leagues*/) {
        const url = `https://v3.football.api-sports.io/fixtures?league=${x/*x.league_id*/}&season=2022&team=${team_id}&from=${yyyy}-${mm}-${dd}&to=2023-08-29&timezone=Europe/Prague`
        axios.get(url ,{headers: headers},)
            .then(async (response) => {
                const res = response.data.response
                for (var x of res) {
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
                    if (found == null) {
                        const add_future_match = FutureMatch.create({
                        fixture_id: x.fixture.id,
                        type: 1,
                        date: 
                            {year: year, month: month, day: day},
                        time: 
                            {hour: hour, minutes: minutes,second: second},
                        place: x.fixture.venue.name,
                        city: x.fixture.venue.city,
                        league: league,
                        round: x.league.round,
                        status_short: x.fixture.status.short,
                        status_long: fixtures_status[x.fixture.status.short],
                        home_team: 
                            {id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo},

                        away_team:
                            {id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo},
                        })
                        add_future_match.save()
                    }
                    else {
                        if (found.status_short != x.fixture.status.short) {
                        await FutureMatch.update({
                            fixture_id: x.fixture.id//x.fixture.date,
                            }, {
                                status_short: x.fixture.status.short,
                                status_long: fixtures_status[x.fixture.status.short],
                                date: 
                                    {year: year, month: month, day: day},
                                time: 
                                    {hour: hour, minutes: minutes,second: second},
                            }
                            )
                        }
                        else if (found.time.hour != hour) {
                            await FutureMatch.update({
                                fixture_id: x.fixture.id
                            }, {
                                status_short: x.fixture.status.short,
                                status_long: fixtures_status[x.fixture.status.short],
                                date: 
                                    {year: year, month: month, day: day},
                                time: 
                                    {hour: hour, minutes: minutes,second: second},
                            }
                            )
                        }
                    }
                    
                }
            })
            .catch((error) => {
                console.log(error.response.statusText, "  Error code:", error.response.status)
            })
    }
    //console.log("Finish")
    return
}

function past_matches() {
    const leagues = ["345", "347"]
    const today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    for (var x of leagues) {
        const url = `https://v3.football.api-sports.io/fixtures?league=${x}&season=2022&team=${team_id}&from=2022-01-01"&to=${yyyy}-${mm}-${dd}&timezone=Europe/Prague`
        axios.get(url ,{headers: headers})
            .then(async (response) => {
                const res = response.data.response
                for (var y of res) {
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
                        type: 1,
                        date: 
                            {year: year, month: month, day: day},
                        time: 
                            {hour: hour, minutes: minutes,second: second},
                        place: y.fixture.venue.name,
                        city: y.fixture.venue.city,
                        league: league,
                        round: y.league.round,
                        status_short: y.fixture.status.short,
                        status_long: fixtures_status[y.fixture.status.short],
                        home_team: 
                            {id: y.teams.home.id, name: y.teams.home.name, logo: y.teams.home.logo, goals: y.goals.home},

                        away_team:
                            {id: y.teams.away.id, name: y.teams.away.name, logo: y.teams.away.logo, goals: y.goals.away},
                    })
                    add_past_match.save()
                    console.log("Past Matches with id: " + y.fixture.id + " is Saved")
                    const eventUrl = `https://v3.football.api-sports.io/fixtures/events?fixture=${y.fixture.id}`
                    await axios.get(eventUrl, {headers: headers})
                        .then(async (response) => {
                            const res = response.data.response
                            for (var z of res) {
                                let assist = z.assist.name
                                let type = z.detail
                                let type_short = z.type
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
                                    fixture_id: y.fixture.id,
                                    event: 
                                        {time: z.time.elapsed, team: z.team.id, player: z.player.name, assist: assist, type: type}
                                })
                                add_event.save()
                                
                            }
                            //console.log("Events for match: " + y.fixture.id + " is Saved")
            
                    })
                }
                return
                //console.log(res)
            })
            .catch(err => {
                console.log(err);
            });
    }
    return;
}


const live_match = async (h, m, fix_id, search_data) =>  {
    let search = "isport blesk fotbal "+ search_data + " online"  
    let start_hour = Number(h)
    let start_minutes = Number(m)
    let live = false
    let events_index = 0
    let updated = false
    //const url = baseUrl + "fixtures?id=" + fix_id + "&timezone=Europe/Prague"
    const url = `https://v3.football.api-sports.io/fixtures?id=${fix_id}&timezone=Europe/Prague`
    console.log(url)
    await axios.get(url ,{headers: headers})
        .then(async (response) => {
            console.log("tas")
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
            const add_match = await Matches.create({
                fixture_id: x.fixture.id,
                type: 1,
                date: 
                    {year: year, month: month, day: day},
                time: 
                    {hour: hour, minutes: minutes,second: second},
                place: x.fixture.venue.name,
                city: x.fixture.venue.city,
                league: league,
                round: x.league.round,
                status_short: x.fixture.status.short,
                status_long: fixtures_status[x.fixture.status.short],
                home_team:
                    {id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo},
                
                away_team:
                    {id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo},
            })
            add_match.save()   
            await FutureMatch.delete({fixture_id: fix_id})
    })
    /*.catch((error) => {
        console.log(error.response.statusText, "  Error code:", error.response.status)
    })*/
    while (live == false) {
        //console.log("While")
        let today = new Date();
        let now_hour/*hot*/ = Number(String(today.getHours() + 1).padStart(2, "0"));
        let now_minutes/*min*/ = Number(String(today.getMinutes()).padStart(2, "0"));
        //var now_hour = Number(hot)
        //var now_minutes = Number(min)
        //var time = String(ho) + String(mi)
        //console.log(ho, mi,  time)
        if (now_hour >= start_hour && now_minutes >= start_minutes) {
            console.log("Match starting", live) 
            await axios.get(url ,{headers: headers})
            .then(async (response) => {
                console.log("Axios")
                let x = response.data.response[0]
                console.log(x)
                console.log(x.fixture.status.short)
                if (x.status.short != "NS") {
                    if (x.status.short == "LIVE" || "1H" || "2H" || "HT") {
                        await Matches.update({
                            fixture_id: fix_id
                        }, {
                            live: true,
                            status_short: x.fixture.status.short,
                            status_long: fixtures_status[x.fixture.status.short],
                        }
                        )
                        console.log("Variable live is true")
                        live = true
                    }
                    else if (x.status.short == "SUSP" || "PST" || "CANC" || "ABD") {
                        await Matches.update({
                            fixture_id: fix_id
                        }, {
                            status_short: x.fixture.status.short,
                            status_long: fixtures_status[x.fixture.status.short],
                        }
                        )
                        return
                    }
                    else if (x.status.short == "INT") {
                        await Matches.update({
                            fixture_id: fix_id
                        }, {
                            status_short: x.fixture.status.short,
                            status_long: fixtures_status[x.fixture.status.short],
                        }
                        )
                        await sleep(60000)
                    } 
                    else {
                        await sleep(60000)
                    }
                }
                else {
                    await sleep(60000)
                }
            })
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
    let current_match = await Matches.findOne({where: {fixture_id: fix_id}})
    while (live == true) {
        //const parameterUrl_events = "fixtures/events?fixture="
        //const parameterUrl = "fixtures?id="
        //const url = baseUrl + parameterUrl + fix_id + "&timezone=Europe/Prague"
        const url = `https://v3.football.api-sports.io/fixtures?id=${fix_id}&timezone=Europe/Prague`
        const url_events = `https://v3.football.api-sports.io/fixtures/events?fixture=${fix_id}`
        //const url_events = baseUrl + parameterUrl_events + fix_id
        //const child = spawn('python', ['src/Python/data_scraping/spiders/comments-scrap.py', search]);
        if (updated == false) {
            current_match = await Matches.findOne({where: {fixture_id: fix_id}})
            updated = true
        }
        await axios.get(url ,{headers: headers})
            .then(async (response) => {
                let x = response.data.response[0]
                let events = x.events
                let current_index = events.length
                if (x.fixture.status.short == "FM") {
                    console.log("Match is finish")
                    await Matches.update({
                        fixture_id: fix_id
                    }, {
                        live: false,
                        home_team:
                            {goals: x.goals.home},
                        away_team: 
                            {goals: x.goals.away},
                        status_short: x.fixture.status.short,
                        status_long: fixtures_status[x.fixture.status.short],
                    })
                    console.log("Konec zápasu")
                    await sleep(300000)
                    //child.kill('SIGTERM');
                    return
                }
                else {
                    let match_elapsed = current_match.elapsed
                    if (match_elapsed.includes("+")) {
                        match_elapsed = "90"
                    }
                    if  (x.goals.home != current_match.home_team.goals || x.goals.away != current_match.away_team.goals || x.fixture.status.short != current_match.status_short || x.fixture.status.elapsed != parseInt(match_elapsed)) {
                        console.log("Difference between current and recieved data")
                        console.log("Goals: ", current_match.home_team.goals, " : ", current_match.away_team.goals, "     Elapsed: ", current_match.elapsed)
                        console.log("Goals: ", x.goals.home, " : ", x.goals.away, "     Elapsed: ", x.fixture.status.elapsed) 
                        if (x.fixture.status.elapsed == "90") {
                            await Matches.update({
                                fixture_id: fix_id
                            }, {
                                home_team:
                                    {goals: x.goals.home},
                                away_team: 
                                    {goals: x.goals.away},
                                elapsed: "90'+",
                                status_short: x.fixture.status.short,
                                status_long: fixtures_status[x.fixture.status.short],
                            })
                            updated = false
                        }
                        else {
                            await Matches.update({
                                fixture_id: fix_id
                            }, {
                                home_team:
                                    {goals: x.goals.home},
                                away_team: 
                                    {goals: x.goals.away},
                                elapsed: x.fixture.status.elapsed,
                                status_short: x.fixture.status.short,
                                status_long: fixtures_status[x.fixture.status.short],
                            })
                            updated = false
                        }
                    }
                    if (current_index == events_index) {
                        console.log("Count of received events and stored events are same")
                        await sleep(180000) //2000
                    }
                    else {
                        console.log("Received new events")
                        let array = events.slice(events_index, current_index)
                        for (var y of array) {
                            let assist = y.assist.name
                            let type = y.detail
                            let type_short = y.type
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
                            let elapsed = y.time.elapsed
                            if (y.time.extra != null) {
                                elapsed = y.time.elapsed+"+"+y.time.extra
                            }
                            console.log("New event:  ",elapsed, "  ",y.team.id,"  ", y.player.name,"  ", assist, "  ",type,"  ", y.time.extra, "  ", y.comments)
                            const add_event = await Events.create({
                                fixture_id: fix_id,
                                event: 
                                {time: elapsed, team: y.team.id, player: y.player.name, assist: assist, type: type, extra_time: y.time.extra}
                            })
                            add_event.save()
                        }
                        events_index = current_index
                    }

                }
                
            })
            .catch((error) => {
                console.log(error.response.statusText, "  Error code:", error.response.status)
            })
        await sleep(30000) //2000 //180000 - 3 Minutes
        /*axios.get(url_events ,{headers: headers})
            .then(async (response) => {                 //Maybe change response name
                let res = response.data.response
                let current_index = res.length
                if (current_index == events_index) {
                    console.log("Count of received events and stored events are same")
                    await sleep(180000) //2000
                }
                else {
                    console.log("Received new events")
                    let max_length = res.length //////// res.length+ 1   Previous code!!!!
                    let array = res.slice(events_index, max_length)
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
                            console.log("New event:  ",x.time.elapsed, "  ",x.team.id,"  ", x.player.name,"  ", assist, "  ",type,"  ", x.time.extra, "  ", x.comments)
                            const add_event = await Events.create({
                                fixture_id: fix_id,
                                event: 
                                {time: x.time.elapsed, team: x.team.id, player: x.player.name, assist: assist, type: type, extra_time: x.time.extra}
                            })
                            add_event.save()
                    }
                    events_index = current_index
                }
            })
            .catch((error) => {
                console.log(error.response.statusText, "  Error code:", error.response.status)
            })*/
    }
}

//const live_match = async (h, m, fix_id, search_data) =>  {}

const match_checker = async () => {
    let today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = String(today.getFullYear());
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
        return null
    }
    else {
        let start_id = String(found.fixture_id)
        let start_hour = found.time.hour 
        let start_minute = found.time.minutes
        let message = "Dnes začíná zápas:" + " " + found.home_team.name + " - " + found.away_team.name + "  " + String(start_hour) + ":" + String(start_minute)
        let search_data = String(found.home_team.name) + " " + String(found.away_team.name) + " " + String(found.date.day) +  "." + String(found.date.month) + " " + String(found.date.year)
        //sms_sender(message)
        console.log("Match_checker found match")
        live_match(start_hour, start_minute, start_id, search_data)
        return
        }
}

const league_data = async () => {
    //Leagues
    const url = `https://v3.football.api-sports.io/leagues?current=true&team=${team_id}`
    axios.get(url ,{headers: headers})
        .then(async (response) => {
            const res = response.data.response
            for (var x of res) {
              const add_league = await Leagues.create({
                league_id: x.league.id,
                league_name: x.league.name, 
                team_id: parseInt(team_id),
              })
              add_league.save()  
            }
        })
}

const test = async () => {
    const fix_id = "880255"
    const url = `https://v3.football.api-sports.io/fixtures?id=${fix_id}&timezone=Europe/Prague`
    axios.get(url ,{headers: headers})
        .then(async (response) => {
            let x = response.data.response[0]
            let events = x.events
            //let current_index = Object.keys(events).length
            let current_index = events.length
            console.log(current_index)
        })
}

const main = async () => {
    const day = 86400000;
   // await future_match()
    await test() 
    //await match_checker()
    //await league_data()
    await setInterval(() => {
        future_match();
    }, day);
    console.log("Function Future_Match has ended")
    await setInterval(() => {
        match_checker();
    }, day);
    console.log("Function Match_Checker has ended")
    /*await setInterval(() => {
        league_data();
    }, day);*/
}   
AppDataSource.initialize().then(() => {
    app.listen(PORT, HOST, () => {
        main();
    })
    //main();
})