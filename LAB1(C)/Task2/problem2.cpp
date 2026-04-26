#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    ifstream file("input2.txt");
    string line;
    getline(file, line);

    vector<string> keywords = {
        "auto","break","case","char","const","continue","default","do",
        "double","else","enum","extern","float","for","goto","if","int",
        "long","register","return","short","signed","sizeof","static",
        "struct","switch","typedef","union","unsigned","void","volatile","while"
    };

    string word;
    stringstream ss(line);

    while (ss >> word) {
        while (!word.empty() && ispunct(word.back())) word.pop_back();

        if (find(keywords.begin(), keywords.end(), word) != keywords.end())
            cout << word << ": Keyword" << endl;
    }
}
