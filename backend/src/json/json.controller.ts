import { Controller, Get, Post, Delete, Param, Body, HttpStatus, HttpCode } from '@nestjs/common';
import { JsonService } from './json.service';
import { CreateJsonDto } from './dto/create-json.dto';
import { JsonEntity } from './entities/json.entity';

@Controller('json')
export class JsonController {
  constructor(private readonly jsonService: JsonService) {}

  @Post()
  create(@Body() createJsonDto: CreateJsonDto): Promise<JsonEntity> {
    return this.jsonService.create(createJsonDto);
  }

  @Get()
  findAll(): Promise<JsonEntity[]> {
    return this.jsonService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string): Promise<JsonEntity> {
    return this.jsonService.findOne(id);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id') id: string): Promise<void> {
    return this.jsonService.remove(id);
  }
}
