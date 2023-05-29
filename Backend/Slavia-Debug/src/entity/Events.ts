import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, ManyToOne } from "typeorm"

@Entity()
export class Events extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @Column()
    fixture_id: number

    @Column('jsonb', {nullable: true, /*array: true, default: {}*/})
    event: {time: number, extra_time: number, team: number, player: string, assist: string, type: string}
    
}