//Diofantoszi egyenletek
#include <iostream>
#define  maxAB 1000
#define  INF maxAB*maxAB+1
using namespace std;

int A,B,N;
int Am[maxAB];
int Bm[maxAB];
bool E[maxAB*maxAB];

int main() {
   cin>>A>>B>>N;
   long long x;
   for(int x=1;x<A;x++) Am[x]=INF;
   for(int x=1;x<B;x++) Bm[x]=INF;
   Am[0]=A; Bm[0]=B;
   E[0]=true;
   for(int x=1;x<=A*B;x++){
      E[x]=(x>=A && E[x-A]) || (x>=B && E[x-B]);
      if (E[x]){
         if(x<Am[x % A]) Am[x % A]=x;
         if(x<Bm[x % B]) Bm[x % B]=x;
      }
   }
   for(int i=0;i<N;i++){
      cin>>x;
      if( x>=Am[x%A] || x>=Bm[x%B])
         cout<<"Igen"<<endl;
      else
         cout<<"Nem"<<endl;
   }
   return 0;
}
