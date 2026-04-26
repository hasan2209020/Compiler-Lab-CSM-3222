#include <iostream>
#include <fstream>
#include <cstring>
using namespace std;


bool isStart(char c) {
    return (c >= 'a' && c <= 'z') ||
           (c >= 'A' && c <= 'Z') ||
            c == '_';
}


bool isValidChar(char c) {
    return (c >= 'a' && c <= 'z') ||
           (c >= 'A' && c <= 'Z') ||
           (c >= '0' && c <= '9') ||
            c == '_';
}

int main() {
    ifstream file("input.txt");
    if (!file) {
        cout << "input.txt not found!\n";
        return 0;
    }

    char line[200];

    while (file.getline(line, 200)) {
        int len = strlen(line);

        for (int i = 0; i < len; i++) {

           
            if (line[i] == '"') {
                i++;
                bool closed = false;

                while (i < len) {
                    if (line[i] == '"') {
                        closed = true;
                        break;
                    }
                    i++;
                }

                if (!closed) {
                    cout << "Error: Unterminated string literal ";
                    cout << "\"" << (line + (i - strlen(line))) << "\n";
                }
            }

            
            if (line[i] == '/' && line[i + 1] == '*') {
                cout << "Error: Unclosed comment\n";
                break;
            }

            
            if (!isStart(line[i]) && (line[i] >= '0' && line[i] <= '9')) {
                // starts with digit → invalid identifier
                int j = i;
                while (j < len && line[j] != ' ' && line[j] != ';')
                    j++;

                cout << "Error: Invalid identifier '" ;
                for (int k = i; k < j; k++) cout << line[k];
                cout << "'\n";

                i = j;
            }

            // inside identifier detect invalid characters @ $ #
            if (isStart(line[i])) {
                int j = i + 1;
                bool bad = false;

                while (j < len && line[j] != ' ' && line[j] != ';') {
                    if (line[j] == '@' || line[j] == '$' || line[j] == '#')
                        bad = true;
                    if (!isValidChar(line[j]))
                        bad = true;
                    j++;
                }

                if (bad) {
                    cout << "Error: Invalid character in identifier ";
                    cout << "'";
                    for (int k = i; k < j; k++) cout << line[k];
                    cout << "'\n";
                }

                i = j;
            }
        }
    }

    return 0;
}
