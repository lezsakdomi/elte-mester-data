#include <iostream>
#define maxN 25
using namespace std;
typedef struct{
   int E;      //a kifizetendő összeg
   int n;      //a pénzek száma
   int P[maxN];//a pénzek
   int k;      //a megoldáskezdemény elemszáma
   int V[maxN];//a megoldáskezdemény vektora
   int osszeg, //a beválasztott pénzek osszege
   maradt;     //még ennyi pénz maradt=szum(P[k+1..n])
} MTerPont;

bool Lehet(MTerPont &X);
bool Megoldas(MTerPont &X);
bool EFiu(MTerPont &X);
bool Testver(MTerPont &X);
bool Apa(MTerPont &X);
//nem rekurzív visszalépéses keresés
bool Keres(MTerPont &X){
   bool van=true, elsore=true;
   while(van){
      if(elsore){
         if(!Lehet(X))
            elsore=false;
         else{
            if(Megoldas(X))
               return true;
            else
               elsore=EFiu(X);
         }
      }else{//nem elsore érintjük a pontot
         elsore=Testver(X);
         if(!elsore)
            van=Apa(X);
      }
   }
   return van;
}

void KiIr(MTerPont X){
   for(int i=1;i<=X.k;i++) cout<<X.V[i]<<","; cout<<endl;
}

int main(){
   MTerPont X;
   bool van;
   cin>>X.n>>X.E;
   for(int i=1;i<=X.n;i++){
      cin>>X.P[i];
      X.maradt+=X.P[i];
   }
   X.osszeg=0; X.k=0; X.V[0]=0;
   van=Keres(X);
   if(van) KiIr(X);
return 0;
}
bool Lehet(MTerPont &X){
   return X.osszeg<=X.E && X.osszeg+X.maradt>=X.E;
}
bool Megoldas(MTerPont &X){
   return X.osszeg==X.E;
}
bool EFiu(MTerPont &X){
   if(X.V[X.k]<X.n){
      X.V[X.k+1]=X.V[X.k]+1;
      (X.k)++;
      X.osszeg+=X.P[X.V[X.k]];
      X.maradt-=X.P[X.V[X.k]];
      return true;
   }else
      return false;
}
bool Testver(MTerPont &X){
   if(X.V[X.k]<X.n){
      X.osszeg-=X.P[X.V[X.k]];
      X.V[X.k]++;
      X.osszeg+=X.P[X.V[X.k]];
      X.maradt-=X.P[X.V[X.k]];
      return true;
   }else
      return false;
}
bool Apa(MTerPont &X){
   if(X.k>1){
      X.osszeg-=X.P[X.V[X.k]];
      X.k--;
      return true;
   }else
      return false;
}
//Rekurzív visszalépéses keresés
#include <iostream>
#define maxN 25
using namespace std;
typedef struct{
   int k;      //a megoldáskezdemény elemszáma
   int u;      //a megoldáskezdemény k. eleme u
   int osszeg, //a beválasztott pénzek osszege
   maradt;     //még ennyi pénz maradt=szum(P[k+1..n])
} MTerPont;

typedef struct{
   int E;      //a kifizetendő összeg
   int n;      //a pénzek száma
   int P[maxN];//a pénzek
   int X[maxN];//a megoldásvektor
} Global;
Global GData;

bool Lehet(MTerPont &X);
bool Megoldas(MTerPont &X);
bool EFiu(MTerPont &X);
bool Testver(MTerPont &X);

bool RKeres(MTerPont X){
   if(Megoldas(X)) return true;
   if(!EFiu(X)) return false;
   do{
      if (Lehet(X))
         if (RKeres(X)){
            GData.X[X.k]=X.u; //a megoldás komponens bejegyzése
            return true;
         }
   }while(Testver(X));
}

void KiIr(){
   for(int i=1;i<=GData.n;i++) cout<<GData.X[i]<<",";
}

int main(){
   MTerPont X;
   bool van;
   cin>>GData.n>>GData.E;
   X.maradt=0;
   for(int i=1;i<=GData.n;i++){
      cin>>GData.P[i];
      X.maradt+=GData.P[i];
   }
   X.osszeg=0; X.k=0; X.u=0;
   RKeres(X);
   KiIr();

return 0;
}
bool Lehet(MTerPont &X){
   return true;
   return X.osszeg<=GData.E && X.osszeg+X.maradt>=GData.E;
}
bool Megoldas(MTerPont &X){
   return X.osszeg==GData.E;
}
bool EFiu(MTerPont &X){
   if(X.u<GData.n){
      X.k++;
      X.u++;
      X.osszeg+=GData.P[X.u];
      X.maradt-=GData.P[X.u];
      return true;
   }else
      return false;
}
bool Testver(MTerPont &X){
   if(X.u<GData.n){
      X.osszeg-=GData.P[X.u];
      X.u++;
      X.osszeg+=GData.P[X.u];
      X.maradt-=GData.P[X.u];
      return true;
   }else
      return false;
}
