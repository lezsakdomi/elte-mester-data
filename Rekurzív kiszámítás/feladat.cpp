#include <iostream>
#define maxN 100001

using namespace std;
typedef struct{
   int bal,jobb;
} Par;
int Inord[maxN], Preord[maxN], Hol[maxN];
Par Fa[maxN];
int FaEpit(int tol1, int ig1, int tol2, int ig2){
//Globális: Preord[], Inord[], Hol
   int x=Preord[tol1];
   if(tol1==ig1){
      Fa[x].bal=0; Fa[x].jobb=0;
      return x;
   }
   int k=Hol[x];
   int b=k-tol2;//a bal részfa elemeinek száma
   if(b>0)
      Fa[x].bal=FaEpit(tol1+1,tol1+b, tol2,k-1);
   else
      Fa[x].bal=0;
   if(k+1<=ig2)
      Fa[x].jobb=FaEpit(tol1+b+1,ig1,k+1,ig2);
   else
      Fa[x].jobb;
   return x;
}
int main(){
   int n;
   cin>>n;
   for(int i=1;i<=n;i++) cin>>Preord[i];
   for(int i=1;i<=n;i++){
      cin>>Inord[i];
      Hol[Inord[i]]=i;
   }
   FaEpit(1,n,1,n);
   for(int i=1;i<=n;i++)
      cout<<Fa[i].bal<<" "<<Fa[i].jobb<<endl;
   return 0;
}
