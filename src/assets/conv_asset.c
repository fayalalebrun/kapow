#include <stdio.h>
#include <stdint.h>

struct __attribute__((packed, aligned(1))) BMPHeader{
  uint8_t b;
  uint8_t m;
  uint32_t size;
  uint32_t reserved;
  uint32_t offset;
  
};

void skip_bytes(int n, FILE* f){
  for(int i = 0; i < n; i++){
    fgetc(f);
  }
}

int main(int argc, char *argv[]){
  
  if(argc != 5){
    printf("Usage: SOURCEFILE OUTPUTFILE width height");
    return 0;
  }

  int width = atoi(argv[3]);
  int height = atoi(argv[4]);

  FILE *source;
  source = fopen(argv[1], "r");
  if(source==0){
    printf("Unable to open source file ");
    printf(argv[1]);
  }
  
  FILE *output;
  output = fopen(argv[2], "w");
  if(output==0){
    printf("Unable to open output file ");
    printf(argv[2]);
  }

  struct BMPHeader head;

  fread(&head, sizeof(head), 1, source);

  skip_bytes(head.offset-sizeof(head), source);


  

  char out[height][width];

  for(int i = height-1; i >= 0; i--){
    for(int z = 0; z < width; z++){
      out[i][z] = fgetc(source);
    }
  }

  
  for(int i = 0; i < height; i++){
    for(int z = 0; z < width; z++){
      fputc(out[i][z], output);
    }
  }
  

  fclose(source);
  fclose(output);
  
  return 0;
}


