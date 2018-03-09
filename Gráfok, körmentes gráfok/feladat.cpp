//Terv
#include <iostream>
#include <vector>
#define maxN 100001
using namespace std;
vector<int> G[maxN];
int BeFok[maxN];
int n;

void Beolvas(){
   int m,p,q;
   cin>>n>>m;
   for(int i=1;i<=n;i++) BeFok[i]=0;
   for (int i=0;i<m;i++){
      cin>>p>>q;
      G[p].push_back(q);
      BeFok[q]++;
   }
}

int main(){
   Beolvas();
   vector<int> Nap[n];
   int hany=0, van=n;
   for (int p=1;p<=n;p++)
      if(BeFok[p]==0)
         Nap[0].push_back(p);

   while(Nap[hany].size()>0){
      for(int p:Nap[hany]){
         van--;
         for (int q:G[p]){
            BeFok[q]--;
            if(BeFok[q]==0)
               Nap[hany+1].push_back(q);
         }
      }//for p
      hany++;
   }
   if(van>0)
      cout<<hany<<endl;
   else{
      cout<<hany<<endl;
      for(int i=0;i<hany; i++){
         for (int p:Nap[i])
            cout<<p<<" ";
         cout<<endl;
      }
   }
 return 0;
 }
