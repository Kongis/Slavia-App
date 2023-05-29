import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany, JoinColumn, UpdateDateColumn, CreateDateColumn } from "typeorm"
@Entity()
export class Comments extends BaseEntity{

    @PrimaryGeneratedColumn("uuid")
    id: string

    @CreateDateColumn()
    created_date: Date

    @UpdateDateColumn()
    updated_date: Date

    @Column()
    fixture_id: number

    @Column()
    time: string
    
    @Column()
    description: string

    @Column()
    type: string
    
}