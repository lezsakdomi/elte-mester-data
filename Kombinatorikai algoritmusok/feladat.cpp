#include <iostream>
#include <stack>
#define maxN 100001

using namespace std;

int main(){
   int n;
   cin>>n;
   int P[n];
   int ui=0; P[0]=n;
   for(int i=1; i<=n; i++){
      cin>>P[i];
      if(P[i-1]<P[i]) ui=i-1;
   }
   //P[ui+1]=n;
   int u=P[ui];
   int vi=ui+1;
   while (P[vi]>u) vi++;
   vi--;
   //v=P[j]
   for(int i=1;i<ui;i++)
      cout<<P[i]<<" ";
   cout<<P[vi]<<" "<<u;;
   for(int i=vi+1;i<=n;i++)
      cout<<" "<<P[i];
   for (int x=P[vi]+1;x<=n;x++)
      cout<<" "<<x;
   cout<<endl;
   return 0;
}
