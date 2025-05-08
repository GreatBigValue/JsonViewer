import { IsObject, IsOptional, IsString } from 'class-validator';

export class CreateJsonDto {
  @IsObject()
  content: object;

  @IsString()
  @IsOptional()
  name?: string;
}
