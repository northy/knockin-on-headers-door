#include <algorithm>
#include <any>
#include <array>
#include <atomic>
#include <barrier>
#include <bit>
#include <bitset>
#include <charconv>
#include <chrono>
#include <codecvt>
#include <compare>
#include <complex>
#include <concepts>
#include <condition_variable>
#include <deque>
#include <exception>
#include <expected>
#include <filesystem>
#include <format>
#include <forward_list>
#include <fstream>
#include <functional>
#include <future>
#include <initializer_list>
#include <iomanip>
#include <ios>
#include <iosfwd>
#include <iostream>
#include <istream>
#include <iterator>
#include <latch>
#include <limits>
#include <list>
#include <locale>
#include <map>
#include <memory>
#include <memory_resource>
#include <mutex>
#include <new>
#include <numbers>
#include <numeric>
#include <optional>
#include <ostream>
#include <print>
#include <queue>
#include <random>
#include <ranges>
#include <ratio>
#include <regex>
#include <scoped_allocator>
#include <semaphore>
#include <set>
#include <shared_mutex>
#include <source_location>
#include <span>
#include <sstream>
#include <stack>
#include <stdexcept>
#include <stop_token>
#include <streambuf>
#include <string>
#include <string_view>
#include <syncstream>
#include <system_error>
#include <thread>
#include <tuple>
#include <type_traits>
#include <typeindex>
#include <typeinfo>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <valarray>
#include <variant>
#include <vector>
#include <version>

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
