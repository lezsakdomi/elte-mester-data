#define maxN 1001
#include "Play.h"    //a 2. játékost megvalósító modul műveletei

int N;               //táblaméret
int A[maxN];         //a táblán lévő számok sorozata
char Lep[maxN][maxN];//az 1. játékos optimális lépései
int Opt[maxN][maxN]; //az 1. játékos Opt[i][j] pontot szerezhet (i,j) játékállásból

void Elofeldolgoz(){
   int PontBal,PontJobb;
   for(int j=1; j<=N;j++){
      Opt[j][j]=0;
      for(int i=j-1; i>0; i--)
      if((i+j)%2==1){//1. játékos lép
         PontBal=A[i]+Opt[i+1][j];
         PontJobb=A[j]+Opt[i][j-1];
         if(PontBal>PontJobb){
            Opt[i][j]=PontBal;
            Lep[i][j]='B';
         }else{
            Opt[i][j]=PontJobb;
            Lep[i][j]='J';
         }
      }else{//2. játékos lép
         if(Opt[i+1][j]<Opt[i][j-1])
            Opt[i][j]=Opt[i+1][j];
         else
            Opt[i][j]=Opt[i][j-1];
      }
   }
}
void Jatszas(){
   int Bal=1,Jobb=N;
   char L2;
   while(Bal<Jobb){
      if(Lep[Bal][Jobb]=='B'){
         Bal++;
         Lepesem('B');
      }else{
         Jobb--;
         Lepesem('J');
      }
      L2=Lepesed();//a válszlépés lekérdezése
      if(L2=='B')
         Bal++;
      else
         Jobb--;
   }
}
int main(){
   N=TablaMeret();
   for (int i=1;i<=N;i++)
      A[i]=Tabla(i);
   Elofeldolgoz();
   Jatszas();
}
//Az alábbi 4 sort mentsük a Play.h állományba és töröljük innen!
extern int TablaMeret();
extern int Tabla(int i);
extern void Lepesem(char l);
extern char Lepesed();
//Az alábbi sorokat mentsük a Play.cpp állományba és töröljük innen!
#include <iostream>
#include <stdlib.h>
#define maxN 1001
using namespace std;

int _N;
int _T[maxN];
bool _Init=true;
int _AktBal,_AktJobb;
int _Nyer1,_Nyer2;
char _lep2;

int TablaMeret(){
   cin>>_N;
   for (int i=1;i<=_N;i++)
      cin>>_T[i];
   _AktBal=1; _AktJobb=_N;
   _Nyer1=0;_Nyer2=0;
   _Init=false;
   return _N;
}
int Tabla(int i){
   if (_Init){
      cout<<"Hiba:előbb TablaMeret-et kell hívni"<<endl;
      exit (1);
   }
   return _T[i];
}
void Lepesem(char l){
   if (_Init){
      cout<<"Hiba:előbb TablaMeret-et kell hívni"<<endl;
      exit (1);
   }
   if (l!='B' && l!='J'){
      cout<<"Hiba:lépésjel csak J vagy B lehet"<<endl;
      exit (1);
   }
   if(l=='B'){
      _Nyer1+=_T[_AktBal++];
   }else{
      _Nyer1+=_T[_AktJobb--];
   }
   if (_T[_AktBal]>_T[_AktJobb]){
      _Nyer2=_T[_AktBal++];
      _lep2='B';
   }else{
      _Nyer2+=_T[_AktJobb--];
      _lep2='J';
   }
   if(_AktBal>_AktJobb){
      cout<<_Nyer1<<' '<<_Nyer2<<endl;
      exit(0);
   }
}
char Lepesed(){
   if (_Init){
      cout<<"Hiba:előbb TablaMeret-et kell hívni"<<endl;
      exit (1);
   }
   return _lep2;
}

