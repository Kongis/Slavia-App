import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"

interface player {
    id: number;
    name: string;
    number: number;
    position: string;
    grid: string;
  }


@Entity()
export class Matches extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @Column()
    type: number

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column()
    fixture_id: number

    @Column({nullable: true})
    raw_date: Date

    @Column('jsonb', {nullable: true, /*array: true*/})
    date: {year: number, month: number, day: number}

    @Column('jsonb', {nullable: true, /*array: true*/})
    time: {hour: number, minutes: number, second: number}

    @Column({default: "Není známo", nullable: false/*array: true*/})
    place: string

    @Column({default: "Není známo", nullable: false/*array: true*/})
    city: string

    @Column({default: "Není známo" /*array: true*/})
    league: string

    @Column({default: "Není známo" /*array: true*/})
    round: string

    @Column({default: false, nullable: true})
    live: boolean

    @Column({default: ""})
    status_short: string

    @Column({default: ""})
    status_long: string

    @Column({default: ""})
    elapsed: string

    @Column('jsonb', {nullable: true, /*array: true*/})
    home_team: {id: number, name: string, logo: string, goals: number}

    @Column('jsonb', {nullable: true, /*array: true*/})
    away_team: {id: number, name: string, logo: string, goals: number}

    @Column('jsonb', {nullable: true})
    home_team_lineups: player[];

    @Column('jsonb', {nullable: true})
    home_team_substitutes: player[];

    @Column({/*nullable: true, */default: 'Není známo'})
    home_team_formation: String

    @Column({nullable: true})
    home_team_color: String 

    @Column('jsonb', {nullable: true})
    away_team_lineups: player[];

    @Column('jsonb', {nullable: true})
    away_team_substitutes: player[];

    @Column({/*nullable: true, */default: 'Není známo'})
    away_team_formation: String

    @Column({nullable: true})
    away_team_color: String 

    /*@Column('jsonb', {nullable: true, array: true})
    comments: {time: number, comments: string, symbol: String}[]*/


    /*addEvents(Event:  {time: number, team: number, player: string, assist: string, type: string}) {
        if (this.events == null) {
            this.events = new Array() 
        }
        console.log(typeof(this.events))
        this.events.push(Event)
    }*/

}

