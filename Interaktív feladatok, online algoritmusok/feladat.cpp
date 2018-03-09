//hírlánc úttömörítéses algoritmusa
#include <iostream>
#include <list>
#include "adatok.h"
#define maxN 100001

using namespace std;

int BeFok[maxN];
int F[maxN];
int Korben[maxN];
int Elore[maxN];

int N;
int V;
void Init(){
   for(int x=1;x<=N;x++){
      F[x] = 0;
      BeFok[x]=0;
      Korben[x]=0;
      Elore[x]=0;
   }
   V=N;
}
int LancVeg(int a){
   int aa=a, x;
   while(Korben[aa]==0 && F[aa]!=0){
      if (Elore[aa]>0)
         aa=Elore[aa];
      else
         aa=F[aa];
   }
   if(a!=aa){
      x=a;
      do{
         Elore[x]=aa;
         x=F[x];
      }while(x!=0 && x!=aa);
   }
   return aa;
}
void szamol(int a, int b){
   int bb=LancVeg(b);
   if(BeFok[b]==0){
      if(bb==a){//1. vagy 2. eset
         int x=b;
         bool farok=false;
         do{
            Korben[x]=1;
            x=F[x];
            if(!farok || BeFok[x]>1) farok=true;
         }while(x!=0);
         if(farok){//2. eset
            V--;
            x=b;
            do{
               Korben[x]=2;
               x=F[x];
            }while(x!=0);
         }
      }else{//3. eset
         V--;
      }
   }else{//BeFok[b]>0
      if(Korben[b]==1){//5. eset
         int x=b;
         do{
            Korben[x]=2;
            x=F[x];
         }while(x!=b);
         V--;
      }//4. eset
   }
   F[a]=b;
   BeFok[b]++;
}

int main(){
   N=kezd();
   Init();
   int a,b;
   for(;;){
      ujadat(a,b);
      szamol(a,b);
      valasz(V);
   }
   return 0;
}
//az alábbi sorokat mentse el az adatok.h fájlba
extern int kezd();
extern void ujadat(int &x, int &y);
extern void valasz(int x);
//az alábbi sorokat mentse el az adatok.cpp fájlba
//adatok könvtári modul
#include <iostream>
#include <stdlib.h>
#define _maxN 100001

using namespace std;

int _N;
int _V;
int _kerd=0;
bool _Init=true;
bool _mvolt=false;
int _A[_maxN]; int _B[_maxN]; int _M[_maxN];
int _h;
int _BeFok[_maxN];
int _F[_maxN];
int _Korben[_maxN];
int _Elore[_maxN];

void Ki(string s){
  cout<<s<<endl;
  exit(0);
}
int _LancVeg(int a){
   int aa=a, x;
   while(_Korben[aa]==0 && _F[aa]!=0){
      if (_Elore[aa]>0)
         aa=_Elore[aa];
      else
         aa=_F[aa];
   }
   if(a!=aa){
      x=a;
      do{
         _Elore[x]=a;
         x=_F[x];
      }while(x!=0 && x!=aa);
   }
   return aa;
}
void _szamol(int a, int b){
   int bb=_LancVeg(b);
   if(_BeFok[b]==0){
      if(bb==a){
         int x=b;
         bool farok=false;
         do{
            _Korben[x]=1;
            x=_F[x];
            if(!farok && _BeFok[x]>1) farok=true;
         }while(x!=0);
         if(farok){
            _V--;
            x=b;
            do{
               _Korben[x]++;
               x=_F[x];
            }while(x!=0);
         }else{

         }
      }else{
         _V--;
      }
   }else{//BeFok[b]>0if (x==0) break;
      if(b==bb && _Korben[b]==1){
         int x=b;
         do{
            _Korben[x]++;
            x=_F[x];
         }while(x!=b);
         _V--;
      }
   }
   _F[a]=b;
   _BeFok[b]++;
}

void _Mego(int i){
   _szamol(_A[i], _B[i]);
   _M[i]=_V;
}
int kezd(){
   cin>>_N;
   _V=_N;
     for(int x=1;x<=_N;x++){
      _F[x] = 0;
      _BeFok[x]=0;
      _Korben[x]=0;
      _Elore[x]=0;
   }
   _mvolt=false;
   _h=1;
   string s;
   int x,y;
   int i=1;
   do{
      cin>>x>>y;
      _A[i]=x; _B[i]=y;
      if (x==0) break;
      getline(cin,s);
      _Mego(i);
      i++;
   }while(true);

   return _N;
}
void ujadat(int &x, int &y){
   if(_mvolt)
      Ki("HIBA: protokoll hiba!");

   x=_A[_h]; y=_B[_h];
   _mvolt=true;
}
void valasz(int db){
   if(!_mvolt){
      Ki("HIBA: protokoll hiba!");
   }
   if(db!=_M[_h])
      Ki("HIBA: hibás válasz!");
   _h++;
   _mvolt=false;
   if(_A[_h]==0){
      cout<<"Helyes"<<endl;
      exit(0);
   }
}
