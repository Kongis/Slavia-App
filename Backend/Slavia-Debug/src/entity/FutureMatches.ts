import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"

@Entity()
export class FutureMatch extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @Column({nullable: true})
    type: number

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column()
    fixture_id: number

    //@Column({nullable: true})
    //date: string

    @Column('jsonb', {nullable: true, /*array: true*/})
    date: {year: number, month: number, day: number}
    /*@Column({nullable: true})
    #time: string*/

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

    @Column({nullable: true})
    status_short: string

    @Column({nullable: true})
    status_long: string

    @Column('jsonb', {nullable: true, /*array: true*/})
    home_team: {id: number, name: string, logo: string, goals: number}

    @Column('jsonb', {nullable: true})
    away_team: {id: number, name: string, logo: string, goals: number}

}