import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"

@Entity()
export class FutureMatch extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @Column()
    type: number

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column({nullable: true, /*array: true*/})
    fixture_id: number

    @Column({nullable: true})
    raw_date: Date

    @Column('jsonb', {nullable: true, /*array: true*/})
    date: {year: number, month: number, day: number}
    /*@Column({nullable: true})
    #time: string*/

    @Column('jsonb', {nullable: true, /*array: true*/})
    time: {hour: number, minutes: number, second: number}

    @Column({default: "Není známo", /*array: true*/})
    place: string

    @Column({default: "Není známo", /*array: true*/})
    city: string

    @Column({default: "Není známo", /*array: true*/})
    league: string

    @Column({default: "Není známo", /*array: true*/})
    round: string

    @Column({default: ""})
    status_short: string

    @Column({default: ""})
    status_long: string

    @Column('jsonb', {nullable: true, /*array: true*/})
    home_team: {id: number, name: string, logo: string, goals: number}

    @Column('jsonb', {nullable: true})
    away_team: {id: number, name: string, logo: string, goals: number}

}