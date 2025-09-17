import <iostream>;
import <map>;
import <vector>;
import <algorithm>;
import <chrono>;
import <random>;
import <memory>;
import <cmath>;
import <thread>;

using namespace std;

void test1()
{
    using namespace chrono;
    using namespace literals;
    auto t0 = system_clock::now();
    double s2 = sqrt(2);
    auto t1 = system_clock::now();
    cout << "sqrt2: " << s2 << " " << (t1 - t0) << "\n";
}

void test2()
{
    vector v = { 1,2,3 };
    map<string, int> m = { {"foo",1}, {"bar",2 } };
    for (auto& [name, val] : m) v.push_back(val);
    for (int x : v) cout << x << " ";
    cout << '\n';
}

void test3()
{
    auto up = make_unique<int>(7);
    auto sp = make_shared<int>(8);
    *up = *sp;
    *sp = 9;
    cout << "up: " << *up << " sp: " << *sp << '\n';
}

void test4(int max)
{
    default_random_engine eng;
    uniform_int_distribution<int> dist(1, max);
    cout << "x: " << dist(eng) << " " << dist(eng) << " " << dist(eng) << '\n';
}

void test5()
{
    jthread t1{ test1 };
    jthread t2{ test2 };
}

int main()
{
    cout << "Hello, world\n";
    test1();
    test2();
    test3();
    test4(17);
    test5();
}
