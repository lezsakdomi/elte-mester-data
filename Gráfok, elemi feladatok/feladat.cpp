//Hálózat központja
#include <iostream>
#include <vector>
#define maxN 10001
using namespace std;
vector<int> G[maxN];
int Fok[maxN];
int n;

void Beolvas(){
   int p,q;
   cin>>n;
   for(int i=1;i<=n;i++) Fok[i]=0;
   for (int i=1;i<n;i++){
      cin>>p>>q;
      G[p].push_back(q);
      G[q].push_back(p);
      Fok[p]++;
      Fok[q]++;
   }
}

int main(){
   Beolvas();
   int E[maxN];
   int eleje=0, vege=0, hany=n, p;
   for (int p=1;p<=n;p++)
      if(Fok[p]==1)
         E[vege++]=p;
   while(hany>1){
      p=E[eleje++];
      hany--;
      for (int q:G[p]){
         Fok[q]--;
         if(Fok[q]==1)
            E[vege++]=q;
      }
   }
   cout<<E[eleje]<<endl;
 return 0;
 }
