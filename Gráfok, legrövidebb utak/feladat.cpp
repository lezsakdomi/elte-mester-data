//Hálózat feladat megoldása Dijkstra algoritmussal
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>
#define maxN 100001
#define Inf 200001
using namespace std;

struct El{
   int pont, suly;
   El(int u, int s){
      pont=u;
      suly=s;
   };
   bool operator<(const El& jobb) const{
      return suly < jobb.suly || (suly==jobb.suly && pont>jobb.pont);
   }
};
vector<El> G[maxN];
priority_queue<El> S;
int n,A,B;

void Beolvas(){
   int m,u,v,s;
   cin>>n>>m;
   cin>>A>>B;
   for(int i=0; i<m; i++){
      scanf("%d %d %d", &u, &v, &s); // cin>>u>>v>>s;
      G[u].push_back(El(v,s));
      G[v].push_back(El(u,s));
   }
}

int Apa[maxN];
int Tav[maxN];
bool Kesz[maxN];

void Dijkstra(int r){
//Globális: G,Kesz,Tav,Apa
   int ujtav;
   El e=El(0,0); El u=El(0,0);
   for (int v = 1; v <= n; ++v){//inicializálás
      Kesz[v]=false; Tav[v]=0;
   }
   Tav[r]=Inf;
   Apa[r]=0;
   S.push(El(r,Tav[r]));
   while (S.size() > 0){
      u=S.top(); S.pop();
      if(Kesz[u.pont]) continue;
      Kesz[u.pont]=true;
      for(El v:G[u.pont]){
         ujtav=min(u.suly, v.suly);
         if (!Kesz[v.pont] && ujtav>Tav[v.pont]){
            e.pont=v.pont; e.suly=ujtav;
            S.push(e);
            Tav[v.pont]=ujtav;
            Apa[v.pont]=u.pont;
         }
      }
   }
}

int main(){
   Beolvas();
   Dijkstra(A);
   int Ut[maxN];
   int x=B;
   int m=0;
   while (x!=A){
      Ut[m++]=x;
      x=Apa[x];
   }
   Ut[m]=A;
   cout<<Tav[B]<<endl;
   for (int i=m; i>=0; i--)
      cout<<Ut[i]<<" ";
   cout<<endl;
}
