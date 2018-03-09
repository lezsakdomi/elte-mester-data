#include <iostream>

using namespace std;

struct allomas{
    int tavolsag;
    int erkIdo;
    int indIdo;
};

int main()
{
    const int MAXN = 100;
    allomas allomasok[MAXN];
    int N;

    cin >> N;
    for(int i=0; i<N; i++){
        cin >> allomasok[i].tavolsag >> allomasok[i].erkIdo >> allomasok[i].indIdo;
    }

    int legkisebbTavolsaguHely = 0;
    for(int i=1; i<N; i++)
        if(allomasok[legkisebbTavolsaguHely].tavolsag > allomasok[i].tavolsag)
            legkisebbTavolsaguHely = i;

    cout << allomasok[legkisebbTavolsaguHely].tavolsag;

    return 0;
}
