#include <iostream>

using namespace std;

const int MaxK=100; //kutyak szama
const int MaxS=100; //szempontok szama

int main(){
    //Valtozok

    int K;
    int S;
    int max[MaxS];
    int min[MaxS];
    int pontok[MaxK][MaxS];

    //be
	cerr << "K=? :";
	cin >> K;
	cerr << "S=? :";
	cin >> S;
    for (int j=0; j<S; j++) {
        cerr << "max[" << j+1 << "]=? :";
        cin >> max[j];
    }
    for (int j=0; j<S; j++) {
        cerr << "min[" << j+1 << "]=? :";
        cin >> min[j];
    }
    int maxp=0;
	for (int i=0; i<K; i++) {
	    for (int j=0; j<S; j++) {
            cerr << "pontok[" << i+1 << "][" << j+1 << "]=? :";
            cin >> pontok[i][j];
            if (pontok[i][j]>maxp) maxp=pontok[i][j];
        }
	}

    cout << maxp << endl;
    return 0;
}
