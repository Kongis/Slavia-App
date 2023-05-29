import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"
import { Events } from "./Events";
@Entity()
export class Matches extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column()
    fixture_id: number

    @Column('jsonb', {nullable: true, /*array: true*/})
    date: {year: number, month: number, day: number}

    @Column('jsonb', {nullable: true, /*array: true*/})
    time: {hour: number, minutes: number, second: number}

    @Column()
    place: string

    @Column()
    city: string

    @Column()
    league: string

    @Column()
    round: string

    @Column()
    status: string

    @Column('jsonb', {nullable: true, /*array: true*/})
    home_team: {id: number, name: string, logo: string, goals: number}

    @Column('jsonb', {nullable: true, /*array: true*/})
    away_team: {id: number, name: string, logo: string, goals: number}

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

