#include <iostream>
#include <fstream>
#include <cctype>
using namespace std;

int main() {
    ifstream file("input.txt");

    if (!file) {
        cout << "Error: Could not open file.\n";
        return 1;
    }

    char ch;
    int chars = 0, words = 0, lines = 0;
    bool inWord = false;

    while (file.get(ch)) {
        chars++;                          

        if (ch == '\n')
            lines++;                      

        if (isspace(ch)) {
            inWord = false;               
        } else {
            if (!inWord) {
                words++;                  
                inWord = true;
            }
        }
    }

    cout << "Total Characters: " << chars << endl;
    cout << "Total Words: " << words << endl;
    cout << "Total Lines: " << lines << endl;

    file.close();
    return 0;
}
