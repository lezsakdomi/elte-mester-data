#include <iostream>
#define maxN 100001
#define maxAB 10001
using namespace std;
typedef struct{int a,b; } Par;
Par S[maxN];
int E[maxAB];
int K[maxAB];

int main(){
   int n,x,y;
   for(int x=0;x<maxAB; x++){
      E[x]=0; K[x]=0;
   }
   cin>>n;
   for(int i=1;i<=n;i++){
      cin>>x>>y;
      S[i].a=x; S[i].b=y;
      E[y]++;
      K[x]++;
   }
   for(x=1;x<maxAB; x++)
         E[x]+=E[x-1];
   for(x=maxAB-1;x>0; x--)
         K[x]+=K[x+1];
   int M=n+1, Mi=0;
   for(int i=1;i<=n; i++){
      int hany=E[S[i].a-1] + K[S[i].b+1];
      if (hany<M) {
         M=hany; Mi=i;
      }
   }
   cout<<Mi<<" "<<n-M-1<<endl;
   return 0;
}
