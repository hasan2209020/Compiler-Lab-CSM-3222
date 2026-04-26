#include <iostream>
#include <fstream>
#include <sstream>
#include <regex>
using namespace std;

int main() {

    ifstream file("input3.txt");   
    string line;
    getline(file, line);           

    regex idRegex("^[a-zA-Z_][a-zA-Z0-9_]*$");   

    string word;
    stringstream ss(line);         

    while (ss >> word) {

        
        if (!word.empty() && word.back() == ',')
            word.pop_back();

        
        if (regex_match(word, idRegex))
            cout << word << ": Valid Identifier" << endl;
        else
            cout << word << ": Invalid Identifier" << endl;
    }
}
