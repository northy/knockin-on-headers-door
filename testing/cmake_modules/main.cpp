#include <format>
#include <print>

import lib;

template <typename T>
struct std::formatter<lib::Point<T>> {
    constexpr auto parse(std::format_parse_context& ctx) {
        return ctx.begin();
    }

    auto format(const lib::Point<T>& obj, std::format_context& ctx) const {
        return std::format_to(ctx.out(), "({}, {})", obj.x, obj.y);
    }
};

int main() {
    const lib::Point<int> p1{3, 4};
    const lib::Point<int> p2{6, 8};
    const auto sum = lib::add(p1, p2);
    std::println("{} + {} = {}", p1, p2, sum);
}
