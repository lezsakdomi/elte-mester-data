//
#include <iostream>
#include <vector>
#define maxN 200001
using namespace std;
typedef vector<int> Graf[];
vector<int> G[maxN];
vector<int> GT[maxN];
int n, p0;

void Beolvas(){
//Globális: G,GT,n,p0
   int m,p,q;
   cin>>n>>m>>p0;
   for (int i=0;i<m;i++){
      cin>>p>>q;
      G[p].push_back(q);
      GT[q].push_back(p);
   }
}
void Eler(Graf G, int p, bool E[]){
   E[p]=true;
   for(int q:G[p])
      if(!E[q])
         Eler(G,q,E);
}

int main(){
   Beolvas();
   bool E[n+1];
   bool ET[n+1];

   for (int p=1;p<=n;p++){
      E[p]=false;
      ET[p]=false;
   }
   Eler(G,p0,E);
   Eler(GT,p0,ET);
   int k=0;
   for(int p=1;p<=n;p++)
      if(E[p] && !ET[p])
         k++;
   cout<<k<<endl;
   for(int p=1;p<=n;p++)
      if(E[p] && !ET[p])
            cout<<p<<" ";
   cout<<endl;
 return 0;
 }
