import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { JsonModule } from './json/json.module';
import { JsonEntity } from './json/entities/json.entity';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DATABASE_HOST || 'postgres',
      port: parseInt(process.env.DATABASE_PORT || '5432', 10),
      username: process.env.DATABASE_USER || 'jsonviewer',
      password: process.env.DATABASE_PASSWORD || 'password',
      database: process.env.DATABASE_NAME || 'jsonviewer',
      entities: [JsonEntity],
      synchronize: true,
    }),
    JsonModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
