import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"

/*interface tag {
    title: string
  }*/

@Entity()
export class ForumPost extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column()
    user_id: string

    @Column()
    username: string

    @Column({default: 0})
    child_count: number

    @Column({default: 0})
    upvote: number

    @Column({default: 0})
    downvote: number

    @Column()
    title: string
    
    @Column()
    text: string
    
    @Column('jsonb', {nullable: true})
    tag: string//tag[];

}