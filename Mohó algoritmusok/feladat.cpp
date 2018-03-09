//Fényképezés
#include <iostream>
#define maxN 3000000
#define maxT 100000
using namespace std;

int Int[maxT];
int M[maxT];

int main(){
   int n, e,t;
   cin>>n;
   for(int x=1;x<=maxT;x++) Int[x]=0;
   for(int i=0;i<n;i++){
       cin>>e>>t;
       if(e>Int[t])
         Int[t]=e;
   }
   int Utolso=0, k=0;
   for(int x=1; x<=maxT; x++)
      if(Int[x]>0 && Utolso<Int[x]){
         Utolso=x-1;
         M[k++]=Utolso;
      }
   cout<<k<<endl;
   for(int i=0;i<k;i++)
      cout<<M[i]<<" ";
   cout<<endl;
 return 0;
}
