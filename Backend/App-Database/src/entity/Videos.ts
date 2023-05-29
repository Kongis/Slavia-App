import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, ManyToOne } from "typeorm"
@Entity()
export class Videos extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

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