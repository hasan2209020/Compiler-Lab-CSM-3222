#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main() {

    ifstream file("input.txt");
    string line;
    getline(file, line);

    cout << "Special Symbols found:\n";

    for (char c : line) {
        if (c == '{') cout << "{ : Special Symbol\n";
        else if (c == '}') cout << "} : Special Symbol\n";
        else if (c == '(') cout << "( : Special Symbol\n";
        else if (c == ')') cout << ") : Special Symbol\n";
        else if (c == '[') cout << "[ : Special Symbol\n";
        else if (c == ']') cout << "] : Special Symbol\n";
        else if (c == ';') cout << "; : Special Symbol\n";
        else if (c == ',') cout << ", : Special Symbol\n";
    }

    return 0;
}
