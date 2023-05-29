import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, ManyToOne } from "typeorm"
import { Matches } from "./Matches";
@Entity()
export class Events extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @Column()
    fixture_id: number

    @Column('jsonb', {nullable: true, /*array: true, default: {}*/})
    event: {time: number, team: number, player: string, assist: string, type: string}
    
}