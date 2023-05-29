import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"
@Entity()
export class Leagues extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column()
    team_id: number

    @Column()
    league_id: number

    @Column({nullable: true})
    league_name: string


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

