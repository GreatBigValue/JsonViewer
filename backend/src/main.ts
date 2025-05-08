import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // Configure CORS with allowed origins from environment variable
  const corsOrigins = process.env.CORS_ORIGINS || 'http://localhost:3000';
  app.enableCors({
    origin: corsOrigins.split(','),
    credentials: true,
  });
  app.useGlobalPipes(new ValidationPipe());
  const port = process.env.PORT || 3001;
  await app.listen(port);
  console.log(`Application is running on port ${port}`);
}
bootstrap();
