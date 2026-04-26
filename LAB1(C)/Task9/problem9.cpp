#include <iostream>
#include <fstream>
using namespace std;

bool isKeyword(string s) {
    string keywords[5] = {"int", "float", "char", "double", "return"};
    for (int i = 0; i < 5; i++) {
        if (s == keywords[i]) return true;
    }
    return false;
}

bool isOperator(char c) {
    char ops[6] = {'+', '-', '*', '/', '=', '%'};
    for (int i = 0; i < 6; i++) {
        if (c == ops[i]) return true;
    }
    return false;
}

bool isSpecial(char c) {
    char sp[6] = {';', '(', ')', '{', '}', ','};
    for (int i = 0; i < 6; i++) {
        if (c == sp[i]) return true;
    }
    return false;
}

bool isDigit(char c) {
    return c >= '0' && c <= '9';
}

bool isAlpha(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_';
}

int main() {

    ifstream file("input.txt");
    if (!file) {
        cout << "File not found!";
        return 0;
    }

    string line;
    char c;

    int keywordCount = 0, idCount = 0, opCount = 0, constCount = 0;
    int spCount = 0, strCount = 0, commentCount = 0;

    while (getline(file, line)) {

        for (int i = 0; i < line.length(); i++) {
            c = line[i];


            if (c == '"') {
                string str = "";
                str += c;
                i++;
                while (i < line.length() && line[i] != '"') {
                    str += line[i];
                    i++;
                }
                str += '"';

                cout << "<" << str << ", string_literal>\n";
                strCount++;
                continue;
            }

    
            if (c == '/' && line[i+1] == '/') {
                cout << "<//..., comment>\n";
                commentCount++;
                break; 
            }

         
            if (isAlpha(c)) {
                string temp = "";
                while (i < line.length() && (isAlpha(line[i]) || isDigit(line[i]))) {
                    temp += line[i];
                    i++;
                }
                i--;

                if (isKeyword(temp)) {
                    cout << "<" << temp << ", keyword>\n";
                    keywordCount++;
                } else {
                    cout << "<" << temp << ", identifier>\n";
                    idCount++;
                }
                continue;
            }


            if (isDigit(c)) {
                string num = "";
                while (i < line.length() && (isDigit(line[i]) || line[i] == '.')) {
                    num += line[i];
                    i++;
                }
                i--;
                cout << "<" << num << ", constant>\n";
                constCount++;
                continue;
            }

  
            if (isOperator(c)) {
                cout << "<" << c << ", operator>\n";
                opCount++;
                continue;
            }


            if (isSpecial(c)) {
                cout << "<" << c << ", special_symbol>\n";
                spCount++;
            }
        }
    }

    
    cout << "\nToken Counts:\n";
    cout << "Keywords: " << keywordCount << "\n";
    cout << "Identifiers: " << idCount << "\n";
    cout << "Constants: " << constCount << "\n";
    cout << "Operators: " << opCount << "\n";
    cout << "Special symbols: " << spCount << "\n";
    cout << "String literals: " << strCount << "\n";
    cout << "Comments: " << commentCount << "\n";

    return 0;
}
