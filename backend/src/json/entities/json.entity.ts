import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity()
export class JsonEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'jsonb' })
  content: object;

  @Column({ nullable: true })
  name: string;

  @CreateDateColumn()
  createdAt: Date;
}
