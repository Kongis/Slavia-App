import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"
@Entity()
export class ForumComment extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    /*@Column()
    post_id: string
    */
    @Column()
    user_id: string

    @Column()
    parent_id: string

    @Column()
    username: string

    @Column({default: 0})
    child_count: number

    @Column({default: 0})
    upvote: number

    @Column({default: 0})
    downvote: number
    
    @Column()
    text: string
    
}