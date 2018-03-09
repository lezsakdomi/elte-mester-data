//
#include <iostream>
#include <vector>
#include <queue>
#define maxN 200001
using namespace std;
typedef vector<int> Graf[];
vector<int> G[maxN];
int n, E,A,R;
const int Inf=maxN+1;
void Beolvas(){
//Globális: G,GT,n,E,A,R
   int m,p,q;
   cin>>n>>m>>E>>A;
   for (int i=0;i<m;i++){
      cin>>p>>q;
      G[p].push_back(q);
   }
}
void SzeltBejar(Graf G, int p, int Tav[], int Apa[]){
   queue<int> S;
   for(int i=1;i<=n;i++) Tav[i]=Inf;
   Tav[p]=0; Apa[p]=0;
   S.push(p);
   int u;
   while (!S.empty()){
      u=S.front(); S.pop();
      for(int v:G[u])
         if(Tav[v]==Inf){
            Tav[v]=Tav[u]+1;
            Apa[v]=u;
            S.push(v);
         }
   }
}

int main(){
   Beolvas();
   int TavE[n+1]; int ApaE[n+1];
   int TavA[n+1]; int ApaA[n+1];
   SzeltBejar(G, A, TavA, ApaA);
   SzeltBejar(G, E, TavE, ApaE);
   int tav=Inf; R=0;
   for(int p=1;p<=n;p++)
   if(TavE[p]<tav && TavA[p]<Inf){
      tav=TavE[p];
      R=p;
   }
   cout<<R<<endl;
   int p=R;
   int Ut[n]; int hol=0;
   while(p>0){
      Ut[hol++]=p;
      p=ApaE[p];
   }
   for(int i=hol-1;i>=0;i--)
      cout<<Ut[i]<<" ";
   cout<<endl;
   p=R; hol=0;
   while(p>0){
      Ut[hol++]=p;
      p=ApaA[p];
   }
   for(int i=hol-1;i>=0;i--)
      cout<<Ut[i]<<" ";
   cout<<endl;

 return 0;
 }
