import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JsonEntity } from './entities/json.entity';
import { CreateJsonDto } from './dto/create-json.dto';

@Injectable()
export class JsonService {
  constructor(
    @InjectRepository(JsonEntity)
    private jsonRepository: Repository<JsonEntity>,
  ) {}

  async create(createJsonDto: CreateJsonDto): Promise<JsonEntity> {
    try {
      // If content is provided as a string, parse it
      if (typeof createJsonDto.content === 'string') {
        createJsonDto.content = JSON.parse(createJsonDto.content);
      }

      const jsonEntity = this.jsonRepository.create(createJsonDto);
      return await this.jsonRepository.save(jsonEntity);
    } catch (error) {
      if (error instanceof SyntaxError) {
        throw new BadRequestException('Invalid JSON format');
      }
      throw error;
    }
  }

  async findAll(): Promise<JsonEntity[]> {
    return await this.jsonRepository.find({
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<JsonEntity> {
    const json = await this.jsonRepository.findOne({ where: { id } });
    if (!json) {
      throw new NotFoundException(`JSON with ID ${id} not found`);
    }
    return json;
  }

  async remove(id: string): Promise<void> {
    const result = await this.jsonRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`JSON with ID ${id} not found`);
    }
  }
}
