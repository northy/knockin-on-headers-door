import lib;
import std;

std::string format(const lib::Point<int>& p) {
    return "(" + std::to_string(p.x) + ", " + std::to_string(p.y) + ")";
}

int main() {
    const lib::Point<int> p1{3, 4};
    const lib::Point<int> p2{6, 8};
    const auto sum = lib::add(p1, p2);
    std::cout << format(p1) << " + " << format(p2) << " = " << format(sum) << std::endl;
}
