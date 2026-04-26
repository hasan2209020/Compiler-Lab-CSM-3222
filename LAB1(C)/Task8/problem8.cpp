#include <iostream>
#include <fstream>
#include <string>
using namespace std;

bool isValidString(const string &s) {
    
    if (s.size() < 2) return false;
    if (s.front() != '"' || s.back() != '"') return false;
    return true;
}

bool isUnterminatedString(const string &s) {
    
    if (s.size() >= 1 && s.front() == '"' && s.back() != '"')
        return true;
    return false;
}

bool isValidChar(const string &s) {
    
    if (s.size() != 3) return false;  
    if (s.front() == '\'' && s.back() == '\'')
        return true;
    return false;
}

bool isEmptyChar(const string &s) {
    
    if (s == "''") return true;
    return false;
}

bool isMultiChar(const string &s) {
    
    if (s.size() > 3 && s.front() == '\'' && s.back() == '\'')
        return true;
    return false;
}

bool isUnterminatedChar(const string &s) {
    
    if (s.front() == '\'' && s.back() != '\'')
        return true;
    return false;
}

int main() {
    ifstream file("input.txt");
    if (!file) {
        cout << "Cannot open input.txt\n";
        return 1;
    }

    string line;
    while (getline(file, line)) {

        
        while (!line.empty() && (line.back() == ' ' || line.back() == '\t'))
            line.pop_back();
        while (!line.empty() && (line.front() == ' ' || line.front() == '\t'))
            line.erase(0, 1);

        cout << line << " : ";

        
        if (!line.empty() && line.front() == '"') {
            if (isValidString(line))
                cout << "Valid String Literal";
            else if (isUnterminatedString(line))
                cout << "Unterminated String Literal";
            else
                cout << "Invalid String Literal";
        }
        
        else if (!line.empty() && line.front() == '\'') {
            if (isEmptyChar(line))
                cout << "Empty Character Constant (Invalid)";
            else if (isValidChar(line))
                cout << "Valid Character Constant";
            else if (isMultiChar(line))
                cout << "Multiple Characters (Invalid)";
            else if (isUnterminatedChar(line))
                cout << "Unterminated Character Constant (Invalid)";
            else
                cout << "Invalid Character Constant";
        }
        else {
            cout << "Not a string or char literal";
        }

        cout << endl;
    }

    return 0;
}
