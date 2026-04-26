#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main() {
    ifstream file("input.txt");
    if (!file) {
        cout << "Cannot open input.txt\n";
        return 1;
    }

    string line;
    bool insideMulti = false;

    while (getline(file, line)) {
        int n = line.size();

        for (int i = 0; i < n; i++) {
            
            if (insideMulti) {
                
                if (i + 1 < n && line[i] == '*' && line[i + 1] == '/') {
                    cout << "Multi-line Comment (closed)" << endl;
                    insideMulti = false;
                    i++; 
                }
                continue;
            }

            
            if (i + 1 < n && line[i] == '/' && line[i + 1] == '/') {
                cout << "Single-line Comment" << endl;
                break; 
            }

            
            if (i + 1 < n && line[i] == '/' && line[i + 1] == '*') {
                insideMulti = true;
                
                bool closed = false;

                for (int j = i + 2; j < n - 1; j++) {
                    if (line[j] == '*' && line[j + 1] == '/') {
                        cout << "Multi-line Comment" << endl;
                        insideMulti = false;
                        closed = true;
                        break;
                    }
                }

                if (insideMulti && !closed) {
                    cout << "Multi-line Comment (starts here)" << endl;
                }

                break;
            }
        }
    }

    
    if (insideMulti) {
        cout << "Unterminated Multi-line Comment (Error)" << endl;
    }

    return 0;
}
