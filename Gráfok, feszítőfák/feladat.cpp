//Hálózatik összekapcsolása Faldása Kruskal algoritmussak
#include <iostream>
#include <algorithm>
#define MaxN 10000
#define MaxM 500000
using namespace std;

struct El{
  int p,q,az;
  long suly;
};
int n,k,m;
El G[MaxM];
int Apa[MaxN];

void UnioHolvan(int n);
int Holvan(int x);
int Unio(int Nx, int Ny);

void Beolvas(){
   int x,y,Nx,Ny;
   cin>>n>>k>>m;
   UnioHolvan(n);
   for(int i=1;i<=k;i++){
      cin>>x;
      Nx=Holvan(x);
      while(true){
         cin>>y;
         if(y==0) break;
         Ny=Holvan(y);
         Nx=Unio(Nx,Ny);
      }
   }
   for(int i=0;i<m;i++){
      cin>>G[i].p>>G[i].q>>G[i].suly;
      G[i].az=i+1;
   }
}

bool rend_rel(const El a, const El b) {
   return a.suly < b.suly;
}

int main(){
   int fael=0 ;
   int Np,Nq;
   Beolvas();
   sort(begin(G),begin(G)+m,rend_rel );

   int okolts=0;
   int Fa[n];
   for (int i=0; i<m; i++){
      Np = Holvan(G[i].p);
      Nq = Holvan(G[i].q);
      if (Np!=Nq){
         Fa[fael++]=G[i].az;
         Unio(Np,Nq);
         okolts+=G[i].suly;
      }
   }
   cout<<okolts<<" "<<fael<<endl;
   for(int i=0;i<fael;i++)
      cout<<Fa[i]<<" ";
   cout<<endl;
}//main
void UnioHolvan(int n){
	for (int x = 1; x <= n; ++x)
		Apa[x] = -1;
}
int Holvan(int x){
	int Nx = x;
	while (Apa[Nx] > 0)
		Nx = Apa[Nx];
	int y = x;
//úttömörités
	while (x != Nx){
		y = Apa[x];
		Apa[x] = Nx;
		x = y;
	}
	return Nx;
}
int Unio(int Nx, int Ny){
	if (Nx == Ny)
		return Nx;
	if (Apa[Nx] > Apa[Ny]){//egyesítés a ngyobbikhoz
		int z = Nx;
		Nx = Ny;
		Ny = z;
	}
	Apa[Nx] += Apa[Ny];
	Apa[Ny] = Nx;
	return Nx;
}

