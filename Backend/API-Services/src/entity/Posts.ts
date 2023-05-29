import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"
import { Matches } from "./Matches";
@Entity()
export class Posts extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column()
    date: string

    @Column()
    title: string

    @Column()
    text: string

    @Column()
    tag: string

    @Column()
    image_url: String

    @Column()
    url: string
    
}