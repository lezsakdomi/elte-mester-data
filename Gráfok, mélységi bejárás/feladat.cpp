#include <iostream>
#include <vector>
#define maxN 10001
using namespace std;
typedef vector<int> Graf[maxN];
Graf G;
int Honnan[maxN];
int n;

void Beolvas(){
   int m,p,q;
   cin>>n;
   for (int i=1;i<=n;i++){
      cin>>q;
      while(q>0){
         G[i].push_back(q);
         cin>>q;
      }
   }
}
void NemrekurzivBejar(Graf G, int n, int p){
   int Honnan[n+1];
   for (int q=1;q<=n;q++)
      Honnan[p]=-1;
   Honnan[p]=0;
   int hol=p,hova,i;

   while(hol!=0){
      cout<<hol<<" ";
      i=0;
      while(i<G[hol].size() && Honnan[G[hol][i]]>=0) i++;
      if (i<G[hol].size()){
         hova=G[hol][i];
         Honnan[hova]=hol;
         hol=hova;
      }else{
         hol=Honnan[hol];//visszalépés
      }
   }
   cout<<endl;
}
void MelyBejar(int p){
//Globális: G,honnan
   cout<<p<<" ";
   for(int q:G[p])
   if (Honnan[q]<0){
      Honnan[q]=p;
      MelyBejar(q);
      cout<<p<<" ";
   }
}
int main(){
   Beolvas();
   for (int i=1; i<=n;i++) Honnan[i]=-1;
   Honnan[1]=0;
   MelyBejar(1);

   return 0;
}
