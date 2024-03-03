#include<iostream>
using namespace std;

int main(int argc, char const *argv[])
{
    int x = 1 + 3;
    printf("%d\n", x);
    string s = "hoge";
    s += "piyo";
    cout << s << endl;

    string s1, s2;
    cin >> s1 >> s2;
    cout << "out: " << s1 << s2 << endl;
    return 0;
}
