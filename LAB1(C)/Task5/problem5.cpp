#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main() {

    ifstream file("input.txt");
    string line;
    getline(file, line);  

    cout << "Operators found:\n";

    bool used[1000] = {false};

    
    string twoOps[] = {"==", "!=", ">=", "<=", "&&", "||"};
    string typeTwo[] = {
        "Relational Operator",
        "Relational Operator",
        "Relational Operator",
        "Relational Operator",
        "Logical Operator",
        "Logical Operator"
    };

    for (int i = 0; i < line.size() - 1; i++) {
        string t = line.substr(i, 2);
        for (int j = 0; j < 6; j++) {
            if (t == twoOps[j]) {
                cout << t << " : " << typeTwo[j] << endl;
                used[i] = used[i + 1] = true;
            }
        }
    }


    for (int i = 0; i < line.size(); i++) {
        if (used[i]) continue;

        char c = line[i];
        if (c == '=') cout << "= : Assignment Operator\n";
        else if (c == '+') cout << "+ : Arithmetic Operator\n";
        else if (c == '-') cout << "- : Arithmetic Operator\n";
        else if (c == '*') cout << "* : Arithmetic Operator\n";
        else if (c == '/') cout << "/ : Arithmetic Operator\n";
        else if (c == '%') cout << "% : Arithmetic Operator\n";
        else if (c == '>') cout << "> : Relational Operator\n";
        else if (c == '<') cout << "< : Relational Operator\n";
        else if (c == '!') cout << "! : Logical Operator\n";
    }

    return 0;
}
