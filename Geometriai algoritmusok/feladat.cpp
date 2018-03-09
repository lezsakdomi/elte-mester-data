//Pontok összekötése zárt poligonná
#include <iostream>
#include <algorithm>
#include <limits.h>
#define   maxN  100000
using   namespace   std ;

typedef   struct {
   long long   x,y;
   long   azon;
} Pont;
Pont   P[maxN];
Pont  Q;    // sarokpont
int Fordul(Pont A, Pont B, Pont C){
/*
Kimenet: +1 ha A->B->C balra fordul,
          0  ha A--B--C kollineárisak,
         -1  ha A->B->C jobbra fordul.
*/
   long long Kereszt=(B.x-A.x)*(C.y-A.y)-(C.x-A.x)*(B.y-A.y);
   if (Kereszt <0)
      return -1;
   else if (Kereszt >0)
      return 1;
   else
      return  0;
}
bool Kozte(Pont A, Pont B, Pont C){
//Bemenet: A-B-C kolineáris
//Kimenet: A és C között van B
   return abs(B.x-A.x) <= abs(C.x-A.x) &&
          abs(C.x-B.x) <= abs(C.x-A.x) &&
          abs(B.y-A.y) <= abs(C.y-A.y) &&
          abs(C.y-B.y) <= abs(C.y-A.y) ;
}
bool SarokRend(Pont A, Pont B){
//Globális: Q
   return Fordul(Q,A,B)>0 || Fordul(Q,A,B)==0 && Kozte(Q,A,B);
}

int   main(){
   int   n,x,y;
   cin>>n;
   Q.x=INT_MAX;
   for( int i=0; i<n; i++){
      cin>>x>>y;
      P[i].azon=i+1;
      P[i].x=x; P[i].y=y;
      if (x<Q.x || x==Q.x  &&  y<Q.y)
         Q=P[i];
   }
   sort(begin(P), begin(P)+n, SarokRend);
   int j=n-2;
   while (j>0  &&  Fordul(Q, P[n-1], P[j])==0) j--;
   for (int i=0; i<=j; i++)
      cout<<P[i].azon<<" ";
   for (int i=n-1; i>j; i--)
      cout<<P[i].azon<<" ";

   return 0;
}
