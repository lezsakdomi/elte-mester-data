#include <iostream>
#define maxN 100001
using namespace std;

int main(){
   int m,n,x,u1,u3,u4;
   int K[maxN];
   cin>>m;
   for(int t=0;t<m;t++){
      n=0; u1=0;
      for(;;){
         cin>>x;
         if (x==0) break;
         K[++n]=x;
         if(x==1) u1=n;
      }
      if (u1==0){
         cout<<"Igen"<<endl;
         continue;
      }
      u4=0; u3=0;
      bool van2=false,van3=false,van4=false;
      bool van43=false, van32=false, van23=false;
      for(int i=u1-1;i>0; i--){
         switch (K[i]){
            case 1:  break;
            case 2:  van2=true;
                     if(u3>0) van23=true;
                     if(u3==0 && u4>0) van32=true;
                     break;
            case 3:  van3=true;
                     if(u4==0) van43=true;
                     if (u4>0 && u3==0) u3=i;
                     break;
            case 4:  van4=true;
                     if(u4==0) u4=i;
                     break;
         }
      }
      if(!van2 || !van3 || !van4){
         cout<<"Igen"<<endl;
         continue;
      }
      if(van23){//van 2-3-4 minta
         cout<<"Nem"<<endl;
         continue;
      }
      if(van32 && van43){//van 3-2-4-3 minta
         van4=false;
         for(int l=u1+1;l<=n;l++)
            if(K[l]==4) van4=true;
         if (van4)
            cout<<"Nem"<<endl;
         else
            cout<<"Igen"<<endl;
      }else{
         cout<<"Igen"<<endl;
      }
   }//for m
   return 0;
}
