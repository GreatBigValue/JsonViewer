import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JsonController } from './json.controller';
import { JsonService } from './json.service';
import { JsonEntity } from './entities/json.entity';

@Module({
  imports: [TypeOrmModule.forFeature([JsonEntity])],
  controllers: [JsonController],
  providers: [JsonService],
})
export class JsonModule {}
