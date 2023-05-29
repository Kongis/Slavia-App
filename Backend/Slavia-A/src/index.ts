import axios from "axios";
import { AxiosResponse, AxiosError } from 'axios'
//import * as bodyParser from "body-parser"
import bodyParser from "body-parser";
import { AppDataSource } from "./data-source"
import { FutureMatch } from "./entity/FutureMatches"
import { Matches } from "./entity/Matches"
import { Events } from "./entity/Events"
import { Leagues } from "./entity/Leagues"
import "reflect-metadata";
import { exit } from "process";
import { url } from "inspector";
//import { DataSource, getManager, getRepository, NoNeedToReleaseEntityManagerError } from "typeorm"
require('dotenv').config()
const { spawn } = require('child_process');
const sleep = (ms) => new Promise(r => setTimeout(r, ms));
const baseUrl = "https://v3.football.api-sports.io/"
const sseAdress = "http://slavia-api:8000/stream/pushdata" //process.env.IP + "/stream/notification"
let headers = {
    Accept: 'application/json', 'Accept-Encoding': 'identity', 
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "53eab603a7c3ec8222692fb4d3270d5c",
}



interface player {
    id: number;
    name: string;
    number: number;
    position: string;
    grid: string;
  }


let json_template = {

}


const team_id = "560" //add new league id
const type = 1

const fixtures_status = {
    "TBD": "Čas bude definován",
    "NS": "Zápas nezačal",
    "1H": "První poločas", //1H //FH
    "HT": "Poločas", 
    "2H": "Druhý poločas", //2H //SH
    "ET": "Hra v prodloužení",
    "BT": "Přestávka",
    "P": "Probíha penalta",
    "SUSP": "Zápas pozastaven",
    "INT": "Zápas přerušen",
    "FT": "Zápas ukončen",
    "AET": "Zápas skončil po prodloužení",
    "PEN": "Zápas skončil po penaltách",
    "PST": "Zápas odložen",
    "CANC": "Zápas zrušen",
    "ABD": "Zápas odložen z různých důvodů",
    "AWD": "Technická ztráta",
    "WO": "",
    "LIVE": "Právě probíhá",

}

const list_notification_channel = {
    "Post": "post_channel",
    "Match": "match_channel",
    "Live": "live_match_channel",
}

const list_notification_path = {
    "Post": "/posts_view",
    "Match": "/match",
    "Live": "/match/match_view",
}

const sendSSE = async (type: string, channel?: string, path?: string, param?: string, title?: string, text?: string, image?: string) => {
    let json_template = { 
        "type": type,
        "channel": channel,
        "path": path,
        "param": param,
        "title": title,
        "text": text,
        "image": image,
    }
    let json = JSON.stringify(json_template)
    await axios.post(sseAdress, json,{headers: {'Content-Type': 'application/json',},})
    /*if (type == "update") {
        sse.send(JSON.stringify(json_template))
    }
    if (type == "notification") {
        
    }*/
}



const future_match = async () => {
    console.log("FutureMatch start")
    let raw_leagues = await Leagues.find({where: {team_id: parseInt(team_id)}})
    const leagues = ["345", "347"] //add new league id
    const today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    for (var x of raw_leagues) {
        const url = `https://v3.football.api-sports.io/fixtures?league=${x.league_id}&season=2022&team=${team_id}&from=${yyyy}-${mm}-${dd}&to=2023-08-29&timezone=Europe/Prague`
        console.log(url)
        await axios.get(url ,{headers: headers},)
            .then(async (response) => {
                const res = response.data.response
                for (var x of res) {
                    let raw_date = x.fixture.date
                    let date1 = raw_date.slice(0, -6)
                    let [dateComponents, timeComponents] = date1.split('T');
                    let [year, month, day] = dateComponents.split("-")
                    let [hour, minutes, second] = timeComponents.split(":")
                    let date_str = year+"-"+month+"-"+day+" "+hour+":"+minutes+":"+second 
                    let date = new Date(date_str)
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
                        type: type,
                        raw_date: date,
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
                        await add_future_match.save()
                        console.log("FutureMatch with fixture_id: ",x.fixture.id, " is saved")
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

const past_matches = async () => {
    let raw_leagues = await Leagues.find({where: {team_id: parseInt(team_id)}})
    //console.log(raw_leagues)
    //console.log(raw_leagues);
    const leagues = ["345", "347"]
    const today = new Date();
    today.setDate(today.getDate() - 1)
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    for (var x of raw_leagues) {
        //console.log(x.league_id)
        const url = `https://v3.football.api-sports.io/fixtures?league=${x.league_id}&season=2022&team=${team_id}&from=2022-01-01&to=${yyyy}-${mm}-${dd}&timezone=Europe/Prague`
        await axios.get(url ,{headers: headers})
            .then(async (response) => {
                const res = response.data.response
                for (var y of res) {
                    let raw_date = y.fixture.date
                    let date1 = raw_date.slice(0, -6)
                    let [dateComponents, timeComponents] = date1.split('T');
                    let [year, month, day] = dateComponents.split("-") 
                    let [hour, minutes, second] = timeComponents.split(":")
                    let date_str = year+"-"+month+"-"+day 
                    let date = new Date(date_str)
                    let league = y.league.name
                    if (league == "Czech Liga"){
                        league = "Fortuna Liga"
                    }
                    if (league == "Cup"){
                        league = "Mol Cup"
                    }
                    let found = await Matches.findOne({where: {fixture_id: y.fixture.id}})
                    if (found == null) {
                        let comments_search = `isport blesk fotbal ${y.teams.home.name} ${y.teams.away.name} online přenos`  
                        const child = spawn('python3', ['src/Python/data_scraping/spiders/comments-scrap.py', comments_search, y.fixture.id.toString(), "True"]);
                        if (y.fixture.venue.name == null) {
                            const add_past_match = await Matches.create({
                            fixture_id: y.fixture.id,
                            type: type,
                            raw_date: date,
                            date: 
                                {year: year, month: month, day: day},
                            time: 
                                {hour: hour, minutes: minutes,second: second},
                            league: league,
                            round: y.league.round,
                            status_short: y.fixture.status.short,
                            status_long: fixtures_status[y.fixture.status.short],
                            home_team: 
                                {id: y.teams.home.id, name: y.teams.home.name, logo: y.teams.home.logo, goals: y.goals.home},

                            away_team:
                                {id: y.teams.away.id, name: y.teams.away.name, logo: y.teams.away.logo, goals: y.goals.away},
                        })
                        await add_past_match.save()
                        }
                        else { 
                            const add_past_match = await Matches.create({
                                fixture_id: y.fixture.id,
                                type: type,
                                raw_date: date,
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
                            await add_past_match.save()
                        }
                        console.log("Match with fixture_id: ", y.fixture.id, " is saved     league: ", league)
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
                                console.log("Event from match with fixture_id: ", y.fixture.id, " is saved")
                                //console.log("Events for match: " + y.fixture.id + " is Saved")
                            }
                        )
                        const lineupstUrl = `https://v3.football.api-sports.io/fixtures/lineups?fixture=${y.fixture.id}`
                        await axios.get(lineupstUrl, {headers: headers})
                            .then(async (response) => {
                                const res = response.data.response
                                if (res.length != 0) {
                                    if (res[0].formation != null) {
                                        let home_lineup: player[] = []
                                        let home_substitutes: player[] = []
                                        let away_lineup: player[] = []
                                        let away_substitutes: player[] = []
                                        let home_formation = res[0].formation
                                        let away_formation = res[1].formation
                                        let home_color = res[0].team.colors.player.primary
                                        let away_color = res[0].team.colors.player.primary
                                        for (var hl of res[0].startXI) {
                                            let player: player = {id: hl.player.id, name: hl.player.name, number: hl.player.number, position: hl.player.pos, grid: hl.player.grid}
                                            home_lineup.push(player)
                                        }
                                        for (var hs of res[0].substitutes) {
                                            let player: player = {id: hs.player.id, name: hs.player.name, number: hs.player.number, position: hs.player.pos, grid: hs.player.grid}
                                            home_substitutes.push(player)
                                        }
                                        for (var al of res[1].startXI) {
                                            let player: player = {id: al.player.id, name: al.player.name, number: al.player.number, position: al.player.pos, grid: al.player.grid}
                                            away_lineup.push(player)
                                        }
                                        for (var as of res[1].substitutes) {
                                            let player: player = {id: as.player.id, name: as.player.name, number: as.player.number, position: as.player.pos, grid: as.player.grid}
                                            away_substitutes.push(player)
                                        }
                                        await Matches.update({
                                            fixture_id: y.fixture.id
                                        },
                                        {
                                            home_team_formation: home_formation,
                                            home_team_lineups: home_lineup,
                                            home_team_substitutes: home_substitutes,
                                            home_team_color: home_color,
                                            away_team_formation: away_formation,
                                            away_team_lineups: away_lineup,
                                            away_team_substitutes: away_substitutes,
                                            away_team_color: away_color,
                                        }
                                        )
                                        console.log("Lineups from match with fixture_id: ", y.fixture.id, " is saved")
                                    }
                                    else {
                                        console.log("Lineups from match with fixture_id: ", y.fixture.id, " doesn't exist")
                                    }
                                }
                            }
                        )

                        
                    }
                    else {
                        console.log("This match is in database")
                    }
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
    await Matches.delete({fixture_id: fix_id})
    await Events.delete({fixture_id: fix_id})
    console.log("live_match")
    let comments_search = "isport blesk fotbal "+ search_data + " online přenos"  
    let comments_fix_id = fix_id;
    let start_hour = Number(h)
    let start_minutes = Number(m)
    let live = false
    let events_index = 0
    let update = false
    let updatedMatch = false
    let home = false
    var getLineup = false
    //const url = baseUrl + "fixtures?id=" + fix_id + "&timezone=Europe/Prague"
    const url = `https://v3.football.api-sports.io/fixtures?id=${fix_id}&timezone=Europe/Prague`
    const lineupsUrl = `https://v3.football.api-sports.io/fixtures/lineups?fixture=${fix_id}`
    await axios.get(url ,{headers: headers})
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
            /*if (status_short == "1H" || status_short == "2H") {
                status_short =
            }*/
            const add_match = Matches.create({
                fixture_id: x.fixture.id,
                type: type,
                date: 
                    {year: year, month: month, day: day},
                time: 
                    {hour: hour, minutes: minutes,second: second},
                raw_date: raw_date,
                place: x.fixture.venue.name,
                city: x.fixture.venue.city,
                league: league,
                round: x.league.round,
                status_short: x.fixture.status.short,
                status_long: fixtures_status[x.fixture.status.short],
                home_team:
                    {id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo, goals: 0},
                
                away_team:
                    {id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo, goals: 0},
                    
            })
            if (x.teams.home.id == team_id) {
                home = true
            }
            console.log(add_match)
            console.log("Current Match saved")
            await add_match.save()   
    })
    while (live == false) {
        const date = new Date()
        let today = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDay(), date.getHours(), date.getMinutes()))
        today.setHours(today.getHours() + 2);
        //new Date(new Date().toLocaleTimeString('en-US', { timeZone: '"Europe/Prague"' }))
        let now_hour/*hot*/ = Number(String(today.getHours()).padStart(2, "0"));
        let now_minutes/*min*/ = Number(String(today.getMinutes()).padStart(2, "0"));
        let starting_time = new Date(Date.UTC(today.getFullYear(), today.getMonth() , today.getDay(), start_hour, start_minutes))
        let lineups_time = new Date(Date.parse(starting_time.toString()) - (1000 * (60 * 40)))
        console.log(`Waiting - ${today}   ${starting_time}`)
        if (today >= starting_time) {
            console.log(`Match starting - ${today}   ${starting_time}`) 
            await axios.get(url ,{headers: headers})
            .then(async (response) => {
                let x = response.data.response[0]
                if (getLineup == false) {
                    const res = response.data.response
                    let home_lineup: player[] = []
                    let home_substitutes: player[] = []
                    let away_lineup: player[] = []
                    let away_substitutes: player[] = []
                    let home_formation = res[0].formation
                    let away_formation = res[1].formation
                    let home_color = res[0].team.colors.player.primary
                    let away_color = res[0].team.colors.player.primary
                    for (var hl of res[0].startXI) {
                        let player: player = {id: hl.player.id, name: hl.player.name, number: hl.player.number, position: hl.player.pos, grid: hl.player.grid}
                        home_lineup.push(player)
                    }
                    for (var hs of res[0].substitutes) {
                        let player: player = {id: hs.player.id, name: hs.player.name, number: hs.player.number, position: hs.player.pos, grid: hs.player.grid}
                        home_substitutes.push(player)
                    }
                    for (var al of res[1].startXI) {
                        let player: player = {id: al.player.id, name: al.player.name, number: al.player.number, position: al.player.pos, grid: al.player.grid}
                        away_lineup.push(player)
                    }
                    for (var as of res[1].substitutes) {
                        let player: player = {id: as.player.id, name: as.player.name, number: as.player.number, position: as.player.pos, grid: as.player.grid}
                        away_substitutes.push(player)
                    }
                    await Matches.update({
                        fixture_id: fix_id
                    }, {
                        home_team_formation: home_formation,
                        home_team_substitutes: home_substitutes,
                        home_team_lineups: home_lineup,
                        home_team_color: home_color,
                        away_team_formation: away_formation,
                        away_team_lineups: away_lineup,
                        away_team_substitutes: away_substitutes,
                        away_team_color: away_color,
                    })
                    getLineup = true
                    console.log(`Match ${fix_id} has lineups`)
                }
                if (x.fixture.status.short != "NS") {
                    if (x.fixture.status.short == "LIVE" || "1H" || "2H" || "HT") {
                        await Matches.update({
                            fixture_id: fix_id
                        }, {
                            live: true,
                            status_short: x.fixture.status.short,
                            status_long: fixtures_status[x.fixture.status.short],
                        }
                        )
                        await FutureMatch.delete({fixture_id: fix_id})
                        live = true
                        await sendSSE("notification", list_notification_channel["Live"], list_notification_path["Live"], fix_id.toString(), `Zápas ${x.teams.home.name} - ${x.teams.away.name} právě začíná`, "");
                        //await sendSSE("remove", "X", "X", "X", fix_id.toString(), "X", "X", "X", "X")
                        await sendSSE("update")
                    }
                    else if (x.status.short == "SUSP" || "PST" || "CANC" || "ABD") {
                        await Matches.update({
                            fixture_id: fix_id
                        }, {
                            status_short: x.fixture.status.short,
                            status_long: fixtures_status[x.fixture.status.short],
                        }
                        )
                        await sendSSE("update")
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
                        await sendSSE("update")
                        await sleep(30000)
                    } 
                    else {
                        await sleep(30000)
                    }
                }
                else {
                    await sleep(30000) // 0.5 min
                }
            })
        }
        else {
            if (getLineup == false) {
                if (today >= lineups_time) {
                    await axios.get(lineupsUrl ,{headers: headers})
                    .then(async (response) => {
                        const results = response.data.results
                        if (results != 0) {
                            let x = response.data.response[0]
                            if (x.lineups.length != 0) {
                                const res = response.data.response
                                let home_lineup: player[] = []
                                let home_substitutes: player[] = []
                                let away_lineup: player[] = []
                                let away_substitutes: player[] = []
                                let home_formation = res[0].formation
                                let away_formation = res[1].formation
                                let home_color = res[0].team.colors.player.primary
                                let away_color = res[0].team.colors.player.primary
                                for (var hl of res[0].startXI) {
                                    let player: player = {id: hl.player.id, name: hl.player.name, number: hl.player.number, position: hl.player.pos, grid: hl.player.grid}
                                    home_lineup.push(player)
                                }
                                for (var hs of res[0].substitutes) {
                                    let player: player = {id: hs.player.id, name: hs.player.name, number: hs.player.number, position: hs.player.pos, grid: hs.player.grid}
                                    home_substitutes.push(player)
                                }
                                for (var al of res[1].startXI) {
                                    let player: player = {id: al.player.id, name: al.player.name, number: al.player.number, position: al.player.pos, grid: al.player.grid}
                                    away_lineup.push(player)
                                }
                                for (var as of res[1].substitutes) {
                                    let player: player = {id: as.player.id, name: as.player.name, number: as.player.number, position: as.player.pos, grid: as.player.grid}
                                    away_substitutes.push(player)
                                }
                                await Matches.update({
                                    fixture_id: fix_id
                                }, {
                                    home_team_formation: home_formation,
                                    home_team_substitutes: home_substitutes,
                                    home_team_lineups: home_lineup,
                                    home_team_color: home_color,
                                    away_team_formation: away_formation,
                                    away_team_lineups: away_lineup,
                                    away_team_substitutes: away_substitutes,
                                    away_team_color: away_color,
                                })
                                getLineup = true
                                console.log(`Match ${fix_id} has lineups`)
                            }
                        }
                    })
                }
            }
            await sleep(30000)
            /*let hours = [5, 4, 3, 2, 1]
            for (var x of hours) {
                if (now_hour == (start_hour - x) && now_minutes == 0) {
                    let msg = "Zápás začíná za" + String(x) + "hodina"
                    console.log(msg)
                    break
                }
                else {
                    continue
                } 
            }*/
            //console.log("cekam")
            //await sleep(60000) //10000 ms - 10s
            }
    }
    let current_match = await Matches.findOne({where: {fixture_id: fix_id}})
    while (live == true) {
        const url = `https://v3.football.api-sports.io/fixtures?id=${fix_id}&timezone=Europe/Prague`
        const url_events = `https://v3.football.api-sports.io/fixtures/events?fixture=${fix_id}`
        const child = spawn('python3', ['src/Python/data_scraping/spiders/comments-scrap.py', comments_search, comments_fix_id, "false"]);
        if (updatedMatch == false) {
            current_match = await Matches.findOne({where: {fixture_id: fix_id}})
            updatedMatch = true
        }
        await axios.get(url ,{headers: headers})
            .then(async (response) => {
                let x = response.data.response[0]
                let events = x.events
                let current_index = events.length
                if (x.fixture.status.short == "FT") {
                    await Matches.update({
                        fixture_id: fix_id
                    }, {
                        live: false,
                        home_team:
                            {goals: x.goals.home, id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo},
                        away_team: 
                            {goals: x.goals.away, id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo},
                        status_short: x.fixture.status.short,
                        status_long: fixtures_status[x.fixture.status.short],
                    })
                    console.log("Konec zápasu")
                    await sendSSE("update");
                    await sleep(300000)
                    child.kill('SIGTERM');
                    await Matches.update({
                        fixture_id: fix_id
                    }, {
                        live: false,
                        home_team:
                            {goals: x.goals.home, id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo},
                        away_team: 
                            {goals: x.goals.away, id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo},
                        status_short: x.fixture.status.short,
                        status_long: fixtures_status[x.fixture.status.short],
                    })
                    return
                }
                else {
                    let match_elapsed = current_match.elapsed

                    if (match_elapsed.includes("+")) {
                        match_elapsed = "90"
                    }
                    if (x.goals.home != current_match.home_team.goals || x.goals.away != current_match.away_team.goals || x.fixture.status.short != current_match.status_short || x.fixture.status.elapsed != parseInt(match_elapsed)) {
                        console.log("Difference between current and recieved data")
                        console.log("Goals: ", current_match.home_team.goals, " : ", current_match.away_team.goals, "     Elapsed: ", current_match.elapsed)
                        console.log("Goals: ", x.goals.home, " : ", x.goals.away, "     Elapsed: ", x.fixture.status.elapsed) 
                        if (home == true && x.goals.home > current_match.home_team.goals || home == false && x.goals.away > current_match.away_team.goals) {
                            //GOOOOOOOOOOOOOOL
                            const notification_title = `Góóóóóóóóól, Slavia právě dala branku. Stav utkání: ${x.goals.home}-${x.goals.away}`
                            await sendSSE("notification", list_notification_channel["Live"], list_notification_path["Live"], fix_id.toString(), notification_title, "Text")
                        }
                        if (home == true && x.goals.home < current_match.home_team.goals || home == false && x.goals.away < current_match.away_team.goals) {
                            //Dostali jsme gol
                            const notification_title = `Slavia právě dostala branku. Stav utkání: ${x.goals.home}-${x.goals.away}`
                            await sendSSE("notification", list_notification_channel["Live"], list_notification_path["Live"], fix_id.toString(), notification_title, "Text")
                        }
                        if (x.fixture.status.elapsed == "90") {
                            await Matches.update({
                                fixture_id: fix_id
                            }, {
                                home_team:
                                    {goals: x.goals.home, id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo},
                                away_team: 
                                    {goals: x.goals.away, id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo},
                                elapsed: "90'+",
                                status_short: x.fixture.status.short,
                                status_long: fixtures_status[x.fixture.status.short],
                            })
                            updatedMatch = false
                            update = true
                        }
                        else {
                            await Matches.update({
                                fixture_id: fix_id
                            }, {
                                home_team:
                                    {goals: x.goals.home, id: x.teams.home.id, name: x.teams.home.name, logo: x.teams.home.logo},
                                away_team: 
                                    {goals: x.goals.away, id: x.teams.away.id, name: x.teams.away.name, logo: x.teams.away.logo},
                                elapsed: x.fixture.status.elapsed,
                                status_short: x.fixture.status.short,
                                status_long: fixtures_status[x.fixture.status.short],
                            })
                            updatedMatch = false
                            update = true
                        }
                    } 
                    if (events.length != 0) {
                        await Events.delete({fixture_id: fix_id})
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
                                if (y.team.id == 560) {
                                    const notification_title = `Góóóóóóóóól, Slavia právě dala branku. Stav utkání: ${x.goals.home}-${x.goals.away}`
                                    const notification_text = 
                                    await sendSSE("notification", list_notification_channel["Live"], list_notification_path["Live"], fix_id.toString(), notification_title, "Text")
                                }
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
                            await add_event.save()
                        }
                        events_index = current_index
                        update = true
                    }
                    if (update == true) {
                        await sendSSE("update")
                        update = false
                    }
                    await sleep(2000)
                }
            })
            /*.catch((error) => {
                console.log(error.response.statusText, "  Error code:", error.response.status)
            })*/
        await sleep(30000) // 0.5 min
    }
}

//const live_match = async (h, m, fix_id, search_data) =>  {}
//992583
const match_checker = async () => {
    //live_match( 18, 45, 992583, "search_data")
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
        .andWhere(`future.type = '1'`)
        .getOne()
    if (found == null) {
        return null
    }
    else {
        //let notification_title = `Dnes začíná zápas ${found.home_team} proti ${found.away_team} v ${found.time.hour}:${found.time.minutes}` 
        //let notification_title = `Dnes začíná zápas ${found.home_team} proti ${found.away_team} v ${found.time.hour}:${found.time.minutes}` 
        let notification_title = `Dnes hrajeme! Zapomeňte na všechno a přijďte fandit Slavii!`
        //let notification_text = `Nezapomeňte na dnešní utkání Slavie proti ${found.away_team}. Zápas začíná v ${found.time.hour}:${found.time.minutes}, tak přijďte fandit našim hráčům na stadion ${found.place} nebo sledujte přenos online.` Začátek utkání je naplánován na 19:00, takže si připravte svoje oblíbené nápoje a jídlo a připojte se k nám při sledování tohoto skvělého zápasu. Podpořme náš tým a věřme, že získají vítězství!
        let notification_text = `Nezapomeňte na dnešní zápas Slavie proti ${found.away_team} v ${found.place}. Začátek utkání je naplánován na ${found.time.hour}:${found.time.minutes}, takže si připravte svoje oblíbené nápoje a jídlo a připojte se k nám při sledování tohoto skvělého zápasu. Podpořte Slavii a věřme, že získá vítězství!` 
        /*if (found.home_team.id == 560) {
            let notification_text = `Dnes začíná zápas `
        }
        if (found.home_team.id == 628 || found.away_team.id == 628) { //Derby

        }
        */
        await sendSSE("notification", list_notification_channel["Match"], list_notification_path["Match"], notification_title, notification_text, "Image", "NotificationLayout.BigText")
        let start_id = String(found.fixture_id)
        let start_hour = found.time.hour 
        let start_minute = found.time.minutes
        let message = "Dnes začíná zápas:" + " " + found.home_team.name + " - " + found.away_team.name + "  " + String(start_hour) + ":" + String(start_minute)
        let search_data = String(found.home_team.name) + " " + String(found.away_team.name) + " " + String(found.date.day) +  "." + String(found.date.month) + " " + String(found.date.year)
        //sms_sender(message)
        live_match( start_hour, start_minute, start_id, search_data)
        return
    }
}

const league_data = async () => {
    //Leagues
    const url = `https://v3.football.api-sports.io/leagues?current=true&team=${team_id}`
    await axios.get(url ,{headers: headers})
        .then(async (response) => {
            const res = response.data.response
            for (var x of res) {
                let found = await Leagues.findOne({where: {league_id: x.league.id}})
                if (found == null) {
                    const add_league = await Leagues.create({
                    league_id: x.league.id,
                    league_name: x.league.name, 
                    team_id: parseInt(team_id),
                  })
                  add_league.save()  
                }
            }
        })
}

const main = async () => {
    const day = 86400000;
        //console.log("ahoj")
    await league_data()
        //await match_checker();
    await past_matches()
    await future_match()
        //console.log("Ende")
    await sleep(3000)
    await match_checker()
    await setInterval(() => {
        future_match();
        console.log("Function Future_Match has ended - A")
    }, day);
    await setInterval(() => {
        match_checker();
        console.log("Function Match_Checker has ended - A")
    }, day);
    await setInterval(() => {
        league_data();
        console.log("Function League_Data has ended - A")
    }, day);
}   
AppDataSource.initialize().then(() => {
    main();
})