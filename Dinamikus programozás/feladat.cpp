//Optimalis Penzvaltas
#include <iostream>

using namespace std;

int main(){
   int n,E;
   cin>>n>>E;
   int P[n+1];
   for(int i=1;i<=n;i++)
      cin>>P[i];
   int Opt[E+1][n+1] ;
   for (int x=1;x<=E; x++) Opt[x][0]=n+1; // 0. sor ki töltése
   for (int i=1;i<=n; i++) Opt[0][i]=0; // 0. oszlop ki töltése
   for (int i=1; i<=n; i++){
      for (int x=1; x<=E; x++){
         Opt[x][i]=Opt[x][i-1];
         if (P[i]<=x && Opt[x][i]>Opt[x-P[i]][i-1]+1)
            Opt[x][i]=Opt[x-P[i]][i-1]+1;
      }
   }
//egy megoldás előállítása visszafejtéssel
   if(Opt[E][n]<=n){
      int S[n+1];
      int m=0;
      int x=E; int i=n;
      do{
         while (i>1 && Opt[x][i]==Opt[x][i-1]) i--;
         S[++m]=i ;
         x-=P[i--];
      }while (x>0);
      cout<<m<<endl;
      for(int i=1;i<m;i++)
         cout<<S[i]<<" ";
      cout<<S[m]<<endl;
   }else{
      cout<<-1<<endl;
   }
 return 0;
 }
