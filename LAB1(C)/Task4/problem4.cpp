#include <iostream>
#include <fstream>
#include <sstream>
#include <regex>
using namespace std;

int main() {

    
    ifstream file("input4.txt");

    
    string line;
    getline(file, line);

    
    regex intRegex("^[0-9]+$");        
    regex floatRegex("^[0-9]+\\.[0-9]+$"); 

    string word;
    stringstream ss(line);  

    
    while (ss >> word) {

        
        while (!word.empty() && ispunct(word.back()))
            word.pop_back();


        if (regex_match(word, intRegex)) {
            cout << word << ": Integer" << endl;
        }
        
        else if (regex_match(word, floatRegex)) {
            cout << word << ": Float" << endl;
        }
    }

    return 0;
}
