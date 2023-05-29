import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, ManyToOne, UpdateDateColumn, CreateDateColumn } from "typeorm"
@Entity()
export class Videos extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column()
    videoID: string

    @Column()
    thumbnail: string

    @Column()
    title: string

    @Column()
    description: string

    @Column()
    publishedTime: string

    @Column()
    lengthVideo: string

    @Column()
    viewCount: string
    
}