#include <stdio.h>
#include <stdint.h>


void skip_bytes(int n, FILE* f){
  for(int i = 0; i < n; i++){
    fgetc(f);
  }
}

int main (int argc, char *argv[]){
  if(argc!=3){
    printf("Usage: SOURCEFILE OUTPUTFILE");
    return 0;
  }



  
  FILE *source;
  source = fopen(argv[1], "r");
  if(source==0){
    printf("Unable to open source file ");
    printf(argv[1]);
    return 1;
  }
  
  FILE *output;
  output = fopen(argv[2], "w");
  if(output==0){
    printf("Unable to open output file ");
    printf(argv[2]);
    return 1;
  }

  
  skip_bytes(124+14, source);

  for(int i = 0; i < 256; i++){
    int b = (int)fgetc(source);
    int g = (int)fgetc(source);
    int r = (int)fgetc(source);
    fgetc(source);
    
    fputc((char)(r>>2), output);
    fputc((char)(g>>2), output);
    fputc((char)(b>>2), output);
   }

  fclose(source);
  fclose(output);
  

  return 0;
}
