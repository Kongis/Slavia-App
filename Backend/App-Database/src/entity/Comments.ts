import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, ManyToOne } from "typeorm"
@Entity()
export class Comments extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @Column()
    time: string

    @Column()
    description: string
    
}