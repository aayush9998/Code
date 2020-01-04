#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>
/****************************************************************************
  This program gives an example of a poor way to implement a password cracker
  in CUDA C. It is poor because it acheives this with just one thread, which
  is obviously not good given the scale of parallelism available to CUDA
  programs.
 
  The intentions of this program are:
    1) Demonstrate the use of __device__ and __global__ functions
    2) Enable a simulation of password cracking in the absence of library
       with equivalent functionality to libcrypt. The password to be found
       is hardcoded into a function called is_a_match.   

  Compile and run with:
  nvcc -o crackpwd_2alph2digt crackpwd_2alpha_2digit.cu


     To Run:
     ./crackpwd_2alph2digt > resultscuda_2alp2dig.txt

  Dr Kevan Buckley, University of Wolverhampton, 2018
*****************************************************************************/

/****************************************************************************
  This function returns 1 if the attempt at cracking the password is
  identical to the plain text password string stored in the program.
  Otherwise,it returns 0.
*****************************************************************************/
__device__ int is_a_match(char *attempt) {
  char password1[] = "DV72";
  char password2[] = "ET21";
  char password3[] = "IR24";
  char password4[] = "SD49";

  char *a = attempt;
  char *y = attempt;
  char *u = attempt;
  char *s = attempt;
  char *pass1 = password1;
  char *pass2 = password2;
  char *pass3 = password3;
  char *pass4 = password4;

  while(*a == *pass1) {
   if(*a == '\0')
    {
    printf("Found password: %s\n",password1);
      break;
    }

    a++;
    pass1++;
  }
    
  while(*y == *pass2) {
   if(*y == '\0')
    {
    printf("Found password: %s\n",password2);
      break;
}

    y++;
    pass2++;
  }

  while(*u == *pass3) {
   if(*u == '\0')
    {
    printf("Found password: %s\n",password3);
      break;
    }

    u++;
    pass3++;
  }

  while(*s == *pass4) {
   if(*s == '\0')
    {
    printf("Found password: %s\n",password4);
      return 1;
    }

    s++;
    pass4++;
  }
  return 0;

}
/****************************************************************************
  The kernel function assume that there will be only one thread and uses
  nested loops to generate all possible passwords and test whether they match
  the hidden password.
*****************************************************************************/

__global__ void  kernel() {
char h,t;
 
  char password[5];
  password[4] = '\0';

int i = blockIdx.x+65;
int j = threadIdx.x+65;
char firstValue = i;
char secondValue = j;
    
password[0] = firstValue;
password[1] = secondValue;
    for(h='0'; h<='9'; h++){
      for(t='0'; t<='9'; t++){
            password[2] = h;
            password[3] = t;
          if(is_a_match(password)) {
        //printf("Success");
          }
             else {
         //printf("tried: %s\n", password);          
            }
          }
        } 
      
}
int time_difference(struct timespec *start,
                    struct timespec *finish,
                    long long int *difference) {
  long long int ds =  finish->tv_sec - start->tv_sec;
  long long int dn =  finish->tv_nsec - start->tv_nsec;

  if(dn < 0 ) {
    ds--;
    dn += 1000000000;
  }
  *difference = ds * 1000000000 + dn;
  return !(*difference > 0);
}


int main() {

  struct  timespec start, finish;
  long long int time_elapsed;
  clock_gettime(CLOCK_MONOTONIC, &start);

kernel <<<26,26>>>();
  cudaThreadSynchronize();

  clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, (time_elapsed/1.0e9));
  return 0;
}




